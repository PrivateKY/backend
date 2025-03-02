FROM node:20-alpine
WORKDIR /app

# Install the latest compatible version of pnpm
RUN npm install -g pnpm@8

# Copy package files first (for better caching)
COPY package.json pnpm-lock.yaml ./

# Force regeneration of the lockfile if needed
RUN pnpm install --frozen-lockfile --force

# Copy the rest of the source code
COPY . .

# Build the app
RUN pnpm run build

# Expose the port and start the server
EXPOSE 80
ENV MWB_SERVER__PORT=80
ENV NODE_ENV=production
CMD ["pnpm", "run", "start"]
