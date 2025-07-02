# Use uma imagem base oficial do Python. A tag 'slim' é uma boa escolha por ser leve.
# A versão 3.11 é compatível com o pré-requisito (3.10 ou superior).
FROM python:3.11-slim

# Define o diretório de trabalho dentro do contêiner.
# Isso evita que os comandos sejam executados na raiz do sistema de arquivos do contêiner.
WORKDIR /app

# Copia o arquivo de dependências primeiro para aproveitar o cache de camadas do Docker.
# Se o requirements.txt não mudar, o Docker reutilizará a camada de instalação das dependências.
COPY requirements.txt .

# Instala as dependências.
# A flag --no-cache-dir desabilita o cache do pip, reduzindo o tamanho da imagem.
RUN pip install --no-cache-dir -r requirements.txt

# Copia o restante do código da sua aplicação para o diretório de trabalho no contêiner.
COPY . .

# Expõe a porta 8000, que é a porta padrão do Uvicorn e a que sua aplicação usa.
EXPOSE 8000

# Comando para iniciar a aplicação quando o contêiner for executado.
# Usamos --host 0.0.0.0 para que a API seja acessível de fora do contêiner.
# O --reload é ótimo para desenvolvimento, mas deve ser removido em um ambiente de produção.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]