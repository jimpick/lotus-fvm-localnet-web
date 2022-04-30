import { promisify } from 'util' 
import { exec } from 'child_process'
import fs from 'fs'

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
  } catch (e) {
    console.error('Exception:', e.message)
    console.error('Code:', e.code)
    console.error('stdout:\n', e.stdout)
    console.error('stderr:\n', e.stderr)
    process.exit(1)
  }
}
run()
