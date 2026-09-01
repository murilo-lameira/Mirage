# 📚 Referência: Otimização Geométrica e Evasão Física (Lee - KIOTS)

## 🔍 Visão Geral
Foca na modelagem e parametrização cinemática de sistemas evasivos para agentes autônomos em ambientes de combate simulados (*Korea Institute of Technology Studies*).

## 💡 Aplicação no Projeto Mirage
- **Engenharia de Movimento:** Descreve como o algoritmo genético atua diretamente sobre parâmetros cinemáticos contínuos de baixo nível: velocidade escalar máxima ($v_{\text{max}}$), limites de aceleração e força de condução vetorial.
- **Teoria de Steering Behaviors (Craig Reynolds):** Conecta a evasão clássica à predição temporal. Em vez de simplesmente fugir da posição presente do projétil, o agente calcula o Ponto de Maior Aproximação (*Closest Point of Approach - CPA*):
  $$t_{\text{cpa}} = -\frac{\vec{p}_r \cdot \vec{v}_r}{|\vec{v}_r|^2}$$
- **Esquiva Perpendicular Preditiva:** Caso o tempo de colisão seja iminente ($0 < t_{\text{cpa}} < 1.5\text{s}$) e a distância projetada seja menor que o raio crítico de perigo, o NPC aplica uma força lateral ortogonal ao vetor de deslocamento do tiro, maximizando o desvio com consumo mínimo de espaço físico na arena.

## 🔗 Conexões
- [[Simulação & Física de Esquiva]]
- [[Função de Fitness]]
- [[00 - MOC Principal]]
