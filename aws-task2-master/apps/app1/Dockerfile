# Dockerfile for App 1
FROM node:20-alpine AS builder
WORKDIR /app
COPY . .
RUN npm install --frozen-lockfile
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app
COPY --from=builder /app .
EXPOSE 3000
CMD ["npm", "start"]
