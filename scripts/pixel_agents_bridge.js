/**
 * Pixel Agents Bridge Local
 * Localizado em: scripts/pixel_agents_bridge.js
 * Executado automaticamente pelo comando 'squad' no terminal.
 */

const fs = require('fs');
const path = require('path');

const ROOT_DIR = path.resolve(__dirname, '..');
const VAULT_DIR = path.join(ROOT_DIR, 'Mirage Obsidian');

// Assegura sincronização do MAIN.md no Obsidian se existir
function ensureObsidianGovernance() {
  if (!fs.existsSync(VAULT_DIR)) return;
  const metaDir = path.join(VAULT_DIR, '00 - Meta');
  if (!fs.existsSync(metaDir)) fs.mkdirSync(metaDir, { recursive: true });
  const mainPath = path.join(metaDir, 'MAIN.md');
  if (!fs.existsSync(mainPath)) {
    fs.writeFileSync(mainPath, `# 🧠 Central de Governança & Guia de Leitura dos Agentes\n\n[[00 - MOC Principal]]\n`, 'utf8');
  }
}

ensureObsidianGovernance();

// Agentes reais configurados para o ecossistema Mirage
const SQUAD = [
  {
    id: 'squad-architect',
    name: 'Arquiteto & Tech Lead (CPA & MAP-Elites)',
    actions: [
      { tool: 'Read', input: { file_path: 'README.md' }, desc: 'Auditando formulações matemáticas e contratos' },
      { tool: 'Edit', input: { file_path: 'docs/FISICA_E_CINEMATICA.md' }, desc: 'Revisando mecânica clássica e evasão vetorial' }
    ]
  },
  {
    id: 'squad-dev',
    name: 'Dev (Simulação & Algoritmo Genético)',
    actions: [
      { tool: 'Edit', input: { file_path: 'src/npc_evasivo_ga.m' }, desc: 'Refatorando loop de evolução e operadores genéticos' },
      { tool: 'Bash', input: { command: 'octave-cli --eval "test_physics"' }, desc: 'Executando testes de integração física' }
    ]
  },
  {
    id: 'squad-qa',
    name: 'QA & Validação Estatística (ANOVA & Boxplots)',
    actions: [
      { tool: 'Bash', input: { command: 'octave-cli --eval "teste_estatistico_hipoteses"' }, desc: 'Rodando Análise de Variância (ANOVA)' },
      { tool: 'Read', input: { file_path: 'data/relatorio_estatistico.txt' }, desc: 'Inspecionando F-statistic e p-valor de convergência' }
    ]
  },
  {
    id: 'squad-vault',
    name: 'Vault Guardian (Obsidian & Governança)',
    actions: [
      { tool: 'Write', input: { file_path: 'MEMORY.md' }, desc: 'Registrando aprendizados e decisões travadas' },
      { tool: 'Edit', input: { file_path: 'Mirage Obsidian/00 - MOCs & Índices/00 - MOC Principal.md' }, desc: 'Garantindo integridade dos grafos do cofre' }
    ]
  }
];

module.exports = { SQUAD };
