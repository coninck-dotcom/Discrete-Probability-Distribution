import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import pareto

# A distribuição de Pareto é conhecida pelo "Princípio de Pareto" ou regra do 80/20.
# É amplamente utilizada para modelar a distribuição de renda, tamanho de cidades
# e ocorrências de sinistros em seguros. Ela possui suporte limitado à esquerda (x >= scale).

# Versão Distribuição de Pareto

# 1. Definição dos parâmetros da Distribuição de Pareto
shape = 3.0  # Parâmetro de forma (alfa) - Deve ser maior que 0
scale = 2.0  # Parâmetro de escala (xm / limite mínimo) - Deve ser maior que 0

# Determinar os limites de visualização baseados nos quantis (0% até 99.9%)
# O ponto inicial exato da distribuição é o valor do próprio parâmetro de escala
x_min = scale
x_max = pareto.ppf(0.999, b=shape, scale=scale)

# 2. Suporte: Valores contínuos iniciando a partir do limite mínimo (scale) até x_max
x = np.linspace(x_min, x_max, 1000)

# 3. Cálculo das funções exatas usando o SciPy nativo
# pareto.pdf equivale a dpareto (Densidade)
# pareto.cdf equivale a ppareto (Acumulada)
fx = pareto.pdf(x, b=shape, scale=scale)
Fx = pareto.cdf(x, b=shape, scale=scale)

# ==============================================================================
# Configuração da figura para os gráficos lado a lado (equivalente ao patchwork)
# ==============================================================================
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))

# Estilo visual limpo (equivalente ao theme_classic)
for ax in [ax1, ax2]:
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.tick_params(top=False, right=False)

# ------------------------------------------------------------------------------
# Gráfico 1: PDF (Função de Densidade de Probabilidade)
# ------------------------------------------------------------------------------
# Desenha a curva contínua da densidade (Decai rapidamente a partir do pico em x_min)
ax1.plot(x, fx, color="steelblue", linewidth=2)
# Preenche a área sob a curva para melhor visualização (alpha controla a transparência)
ax1.fill_between(x, fx, color="steelblue", alpha=0.15)

# Configurações de eixos e títulos dinâmicos
ax1.set_xlim(x_min, x_max)
ax1.set_ylim(0, max(fx) * 1.1)
ax1.set_title(f"Função de Densidade (PDF) - Pareto(shape={shape}, scale={scale})", weight='bold', pad=15)
ax1.set_xlabel("Valor (x)")
ax1.set_ylabel("f(x)")

# ------------------------------------------------------------------------------
# Gráfico 2: CDF (Função de Distribuição Acumulada Contínua)
# ------------------------------------------------------------------------------
# Desenha a curva contínua acumulada (Inicia exatamente no valor de scale)
ax2.plot(x, Fx, color="darkorange", linewidth=2)

# Configurações de eixos e títulos
ax2.set_xlim(x_min, x_max)
ax2.set_ylim(0, 1.05)
ax2.set_yticks(np.arange(0, 1.1, 0.2))  # Quebras de 0 até 1 de 0.2 em 0.2
ax2.set_title("Distribuição Acumulada (CDF)", weight='bold', pad=15)
ax2.set_xlabel("Valor (x)")
ax2.set_ylabel("F(x) = P(X <= x)")

# Ajusta o espaçamento para não cortar os textos
plt.tight_layout()

# Salvar como JPEG (Equivalente ao ggsave)
# plt.savefig("figPareto.jpeg", dpi=300, format="jpeg")

# Exibir os gráficos na tela (Equivalente ao x11() + plot)
plt.show()
