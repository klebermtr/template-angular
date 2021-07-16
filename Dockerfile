### STAGE 1: Build ###
FROM node:10-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN $(npm bin)/ng build --prod --output-path=dist

### STAGE 2: Setup ###
FROM nginx:1.14.1-alpine
COPY nginx/default.conf /etc/nginx/conf.d/
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]