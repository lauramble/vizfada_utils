# Stage 1: build 
FROM node:14.13.1 as build
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app/
RUN npm run build -- --configuration production

# Stage 2: serve
FROM nginx:1.17.1
RUN rm -rf /usr/shar/nginx/html/*
COPY --from=build /app/dist/VizFaDa /usr/share/nginx/html
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf
