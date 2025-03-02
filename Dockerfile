FROM node:20-alpine
WORKDIR /app

# Install pnpm manually instead of using Corepack
RUN npm install -g pnpm@latest

# Copy package files first (for better layer caching)
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy the rest of the source code
COPY . .

# Build the app
RUN pnpm run build

# Expose the port and start the server
EXPOSE 80
ENV MWB_SERVER__PORT=80
ENV NODE_ENV=production
CMD ["pnpm", "run", "start"]
