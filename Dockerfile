FROM thevlang/vlang:alpine
COPY . .
RUN v -prod -o vpipka build vpipka.v
ENTRYPOINT [ "vpipka" ]
CMD [ "3000" ]