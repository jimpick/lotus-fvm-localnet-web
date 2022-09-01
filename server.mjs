import { promisify } from 'util' 
import { exec } from 'child_process'
import fs from 'fs'

import Fastify from 'fastify'
import fastifyCors from '@fastify/cors'
import { encode } from 'borc'
import rawBody from 'raw-body'

const execWithPromise = promisify(exec)

const fastify = Fastify({
  logger: true
})

fastify.register(fastifyCors)

// https://stackoverflow.com/questions/61122089/how-do-i-access-the-raw-body-of-a-fastify-request

fastify.addContentTypeParser('binary/octet-stream', (req, done) => {
  rawBody(req, {
      length: req.headers['content-length'],
      limit: '1mb',
      // encoding: 'utf8', // Remove if you want a buffer
  }, (err, body) => {
      if (err) return done(err)
      // done(null, parse(body))
      done(null, body)
  })
})

fastify.post('/compile', async (request, reply) => {
  // console.log('Request body', request.body)
  if (!request.body || !request.body['lib.rs']) {
    return (
      reply
        .code(400)
        .header('Content-Type', 'application/json; charset=utf-8')
        .send({
          error: 'Missing data for lib.rs'
        })
    )
  }

  fs.writeFileSync('fil-hello-world-actor/src/lib.rs', request.body['lib.rs'])
  if (request.body['Cargo.toml']) {
    fs.writeFileSync('fil-hello-world-actor/Cargo.toml', request.body['Cargo.toml'])
  }

  try {
    const { stdout, stderr } = await execWithPromise(
      'cargo build',
      {
        cwd: 'fil-hello-world-actor'
      }
    )
    const buffer = fs.readFileSync(
      'fil-hello-world-actor/target/debug/wbuild/' +
      'fil_hello_world_actor/fil_hello_world_actor.compact.wasm'
    )
    const encoded = encode([ buffer ])
    const base64Encoded = encoded.toString('base64')
    return {
      success: true,
      logs: stderr,
      wasmBinaryParamsEncoded: base64Encoded
    }
  } catch (e) {
    console.error('Exception:', e.message)
    console.error('Code:', e.code)
    console.error('stdout:\n', e.stdout)
    console.error('stderr:\n', e.stderr)
    return (
      reply
        .code(400)
        .header('Content-Type', 'application/json; charset=utf-8')
        .send({
          success: false,
          code: e.code,
          error: e.stderr
        })
    )
  }
})

fastify.post('/compile-evm', async (request, reply) => {
  // console.log('Request body', request.body)
  if (!request.body || !request.body['contract.sol']) {
    return (
      reply
        .code(400)
        .header('Content-Type', 'application/json; charset=utf-8')
        .send({
          error: 'Missing data for contract.sol'
        })
    )
  }

  fs.rmSync('evm-contract', { recursive: true, force: true })
  fs.mkdirSync('evm-contract/output', { recursive: true })
  fs.writeFileSync('evm-contract/contract.sol', request.body['contract.sol'])

  try {
    const { stdout, stderr } = await execWithPromise(
      'solc --bin -o output contract.sol',
      {
        cwd: 'evm-contract'
      }
    )
    let evmBinary = null
    const files = fs.readdirSync('evm-contract/output')
    for (const file of files) {
      evmBinary = fs.readFileSync('evm-contract/output/' + file, 'utf8')
      continue
    }
    return {
      success: true,
      logs: stderr,
      evmBinary
    }
  } catch (e) {
    console.error('Exception:', e.message)
    console.error('Code:', e.code)
    console.error('stdout:\n', e.stdout)
    console.error('stderr:\n', e.stderr)
    return (
      reply
        .code(400)
        .header('Content-Type', 'application/json; charset=utf-8')
        .send({
          success: false,
          code: e.code,
          error: e.stderr
        })
    )
  }
})

let fileCounter = 0

fastify.post('/upload', async (request, reply) => {
  if (!request.body) {
    return (
      reply
        .code(400)
        .header('Content-Type', 'application/json; charset=utf-8')
        .send({
          error: 'Missing data'
        })
    )
  }

  const filename = `/tmp/file-${fileCounter++}.bin`

  try {
    fs.writeFileSync(filename, request.body)

    return {
      success: true,
      filename
    }
  } catch (e) {
    console.error('Exception:', e.message)
    console.error('Code:', e.code)
    console.error('stdout:\n', e.stdout)
    console.error('stderr:\n', e.stderr)
    return (
      reply
        .code(400)
        .header('Content-Type', 'application/json; charset=utf-8')
        .send({
          success: false,
          code: e.code,
          error: e.stderr
        })
    )
  }
})

// const port = process.env.PORT || 3000
const port = 4000

const start = async () => {
  try {
    await fastify.listen(port, '0.0.0.0')
  } catch (err) {
    fastify.log.error(err)
    process.exit(1)
  }
}
start()
