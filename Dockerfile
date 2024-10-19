# Usamos una imagen base de node para construir el proyecto
FROM node:18-alpine as build-stage

# Establecemos el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiamos el package.json y el package-lock.json para instalar las dependencias
COPY package*.json ./

# Instalamos las dependencias
RUN npm install

# Copiamos el resto del código del proyecto al contenedor
COPY . .

# Construimos el proyecto para producción
RUN npm run build

# Ahora usamos una imagen de nginx para servir la aplicación construida
FROM nginx:alpine as production-stage

# Copiamos los archivos construidos a la carpeta de nginx
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Exponemos el puerto 80 para acceder a la aplicación
EXPOSE 80

# Iniciamos nginx
CMD ["nginx", "-g", "daemon off;"]
