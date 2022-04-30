import Fastify from 'fastify'
import fastifyCors from '@fastify/cors'

const fastify = Fastify({
  logger: true
})

fastify.register(fastifyCors)

fastify.post('/compile', async (request, reply) => {
  return {
    success: true,
    binary: "xxx",
    logs: "yyy"
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
