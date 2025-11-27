# Stage 1: Build the Vite app
FROM node:20 AS build

# Рабочая директория
WORKDIR /app

# Копируем только package.json и package-lock.json, чтобы использовать кэширование Docker
COPY package*.json ./

# Устанавливаем зависимости внутри контейнера (для Linux)
RUN npm ci

# Копируем все исходники
COPY . .

# Сборка Vite-приложения
RUN npm run build

# Stage 2: Serve build
FROM node:20-slim

WORKDIR /app

# Устанавливаем serve для статической отдачи
RUN npm install -g serve

# Копируем только собранную папку dist из build stage
COPY --from=build /app/dist ./dist

# Открываем порт
EXPOSE 3000

# Запуск приложения
CMD ["serve", "-s", "dist", "-l", "3000"]
