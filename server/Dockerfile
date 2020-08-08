FROM node:alpine

WORKDIR /application

ENV PORT 3000

COPY dist/index.js .

EXPOSE 3000

CMD [ "node", "index.js" ]
