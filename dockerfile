# Use a imagem oficial do Nginx
FROM nginx:stable-alpine

# Copia os arquivos da build Flutter para o diretório padrão do Nginx
COPY /build/web /usr/share/nginx/html

# Copia configuração customizada do Nginx (opcional)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expõe a porta 80
EXPOSE 80

# Comando para rodar o Nginx
CMD ["nginx", "-g", "daemon off;"]


