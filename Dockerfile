# /app

#Dependencias de desarrollo
FROM node:19.2-alpine3.16 as deps

# cd app
WORKDIR /app

# Dest /app
COPY package.json ./

# Instalar las dependencias
RUN npm install


#Build y test
FROM node:19.2-alpine3.16 as builder

# cd app
WORKDIR /app

# Copiar las despendencias del anterior stage
COPY --from=deps /app/node_modules ./node_modules

# Dest /app
COPY . .

# Realizar testing
RUN npm run test

#Dependencias de producción
FROM node:19.2-alpine3.16 as prod-deps

# cd app
WORKDIR /app

COPY package.json ./ 
# Realizar instalaciones de dependencias de producción
RUN npm install --prod


#Ejecutar la APP
FROM node:19.2-alpine3.16 as runner

WORKDIR /app

# Copiar las despendencias del anterior stage
COPY --from=prod-deps /app/node_modules ./node_modules

# Dest /app
COPY app.js ./
COPY tasks/ ./task

#Comando run de la imagen
CMD ["node","app.js"]