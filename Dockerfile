FROM node:20-slim

RUN apt-get update && apt-get install -y python3 python3-pip git && rm -rf /var/lib/apt/lists/*

RUN npm install -g @anthropic-ai/claude-code

USER node
WORKDIR /workspace

CMD ["/bin/bash"]