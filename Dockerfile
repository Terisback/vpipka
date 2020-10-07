FROM thevlang/vlang:alpine
COPY . .
RUN v -prod -o vpipka build .
ENTRYPOINT [ "vpipka" ]
CMD [ "3000" ]