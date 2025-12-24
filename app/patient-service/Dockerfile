FROM public.ecr.aws/lambda/nodejs:22

COPY package.json ${LAMBDA_TASK_ROOT}

RUN npm install

COPY index.js ${LAMBDA_TASK_ROOT}

CMD ["index.handler"]
