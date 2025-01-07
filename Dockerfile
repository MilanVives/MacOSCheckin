# Specify platform and use Node.js LTS (Long Term Support) version
FROM --platform=linux/amd64 node:20-slim

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# Copy package.json and package-lock.json (if available)
COPY package*.json ./

RUN npm install

# Bundle app source
COPY . .

# Your app binds to port 3100
EXPOSE 3100

# Update MongoDB connection string for Docker
ENV MONGODB_URI=mongodb://mongo:27017/clientDB

# Start the application
CMD [ "node", "app.js" ] 