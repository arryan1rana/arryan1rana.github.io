import { defineConfig } from 'vite';

const repository = process.env.GITHUB_REPOSITORY || '';
const owner = process.env.GITHUB_REPOSITORY_OWNER || '';
const repositoryName = repository.split('/')[1] || '';
const isPersonalSite = repositoryName.toLowerCase() === `${owner.toLowerCase()}.github.io`;
const base = repository ? (isPersonalSite ? '/' : `/${repositoryName}/`) : '/';

export default defineConfig({ base });
