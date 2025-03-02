FROM node:20-alpine
WORKDIR /app

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

# Copy package files first (better layer caching)
COPY package.json pnpm-lock.yaml ./

# Force a clean install (removes caching issues)
RUN pnpm fetch && pnpm install --no-frozen-lockfile --force

# Copy the rest of the source code
COPY . .

# Build the app
RUN pnpm run build

# Expose the port and start the server
EXPOSE 80
ENV MWB_SERVER__PORT=80
ENV NODE_ENV=production
CMD ["pnpm", "run", "start"]
