# Pull Node18
FROM node:18

# Working directory
WORKDIR /app

# Copy files
COPY server.js .
COPY package.json .
COPY package-lock.json .
COPY .eslintrc.js .

# Expose 3000
EXPOSE 3000

# Run npm start
CMD ["npm", "start"]
