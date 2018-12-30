### STAGE 1: Build ###
FROM node:10-alpine as builder
WORKDIR /app
COPY . .
RUN npm install --silent
RUN npm run build

### STAGE 2: Production environment ###
FROM nginx:1.14.1-alpine
COPY --from=builder /app/build /usr/share/nginx/html
