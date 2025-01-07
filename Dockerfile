FROM node:18-alpine AS base

# This will be set by the GitHub action to the folder containing this component.
ARG FOLDER=.

# Install dependencies only when needed
FROM base AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat

COPY . .
WORKDIR ${FOLDER}

# Install dependencies based on the preferred package manager
RUN \
  if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
  elif [ -f package-lock.json ]; then npm ci; \
  elif [ -f pnpm-lock.yaml ]; then corepack enable pnpm && pnpm i --frozen-lockfile; \
  else echo "Lockfile not found." && exit 1; \
  fi

# Rebuild the source code only when needed
FROM base AS builder
COPY . .
WORKDIR ${FOLDER}
COPY --from=deps ${FOLDER}/node_modules ./node_modules

# Next.js collects completely anonymous telemetry data about general usage.
# Learn more here: https://nextjs.org/telemetry
# Uncomment the following line in case you want to disable telemetry during the build.
# ENV NEXT_TELEMETRY_DISABLED=1

RUN \
  if [ -f yarn.lock ]; then yarn run build; \
  elif [ -f package-lock.json ]; then npm run build; \
  elif [ -f pnpm-lock.yaml ]; then corepack enable pnpm && pnpm run build; \
  else echo "Lockfile not found." && exit 1; \
  fi

# Create the public folder if it does not exist
RUN mkdir -p ./public

# Production image, copy all the files and run next
FROM base AS runner
COPY . .
WORKDIR ${FOLDER}

# Clear the Next.js component folder as it will be populated by the build output.
RUN rm -rf *

# NOTE! We default to this now, production needs to be solved later
ENV NODE_ENV=development
# Uncomment the following line in case you want to disable telemetry during runtime.
# ENV NEXT_TELEMETRY_DISABLED=1

# This would be good in production, but impractial in dev, since next wan't to touch node_modules itself
#RUN addgroup --system --gid 1001 nodejs
#RUN adduser --system --uid 1001 nextjs

COPY --from=builder ${FOLDER}/public ./public

# Set the correct permission for prerender cache
#RUN mkdir .next
#RUN chown nextjs:nodejs .next

# Automatically leverage output traces to reduce image size
# https://nextjs.org/docs/advanced-features/output-file-tracing
#COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
#COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
COPY --from=builder ${FOLDER}/.next/standalone ./
COPY --from=builder ${FOLDER}/.next/static ./.next/static


USER node

EXPOSE 3000

ENV PORT=3000

# server.js is created by next build from the standalone output
# https://nextjs.org/docs/pages/api-reference/next-config-js/output
ENV HOSTNAME="0.0.0.0"
CMD ["npm", "run", "dev"]
