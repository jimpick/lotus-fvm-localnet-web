import { promisify } from 'util' 
import { exec } from 'child_process'
import fs from 'fs'
import { encode } from 'borc'

const execWithPromise = promisify(exec)

async function run () {
  try {
    // const { stdout, stderr } = await execWithPromise('ls')
    //const { stdout, stderr } = await execWithPromise('exit 2')
    const { stdout, stderr } = await execWithPromise(
      'cargo build',
      {
        cwd: 'fil-hello-world-actor'
      }
    )
    console.log('stdout:\n', stdout)
    console.error('stderr:\n', stderr)
    const buffer = fs.readFileSync(
      'fil-hello-world-actor/target/debug/wbuild/' +
      'fil_hello_world_actor/fil_hello_world_actor.compact.wasm'
    )
    console.log('bytes:\n', buffer)
    const encoded = encode([ buffer ])
    console.log('cbor:\n', encoded)
    fs.writeFileSync('encoded.bin', encoded)
    const base64Encoded = encoded.toString('base64')
    console.log('base64:\n', base64Encoded.slice(0, 20) + '...' + base64Encoded.slice(-20))
  } catch (e) {
    console.error('Exception:', e.message)
    console.error('Code:', e.code)
    console.error('stdout:\n', e.stdout)
    console.error('stderr:\n', e.stderr)
    process.exit(1)
  }
}
run()
