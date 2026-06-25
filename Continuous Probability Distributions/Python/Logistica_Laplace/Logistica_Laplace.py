import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import logistic

# A distribuição Logística é frequentemente utilizada em modelos de regressão 
# logística, redes neurais (função sigmoide) e para modelar o crescimento de 
# populações. Suas caudas são ligeiramente mais pesadas que as da distribuição Normal.

# Versão Distribuição de Logística

# 1. Definição dos parâmetros da Distribuição Logística
location = 0  # Parâmetro de localização (média/mediana/pico central)
scale = 1     # Parâmetro de escala (grau de dispersão) - Deve ser maior que 0

# Determinar limites adequados para focar no pico e cobrir ~99.8% da distribuição
# logistic.ppf equivale à função qlogis do R (Percent Point Function / Quantil)
x_min = logistic.ppf(0.001, loc=location, scale=scale)
x_max = logistic.ppf(0.999, loc=location, scale=scale)

# 2. Suporte: Valores contínuos de x_min até x_max
x = np.linspace(x_min, x_max, 1000)

# 3. Cálculo das funções exatas usando o SciPy nativo
# logistic.pdf equivale a dlogis (Densidade)
# logistic.cdf equivale a plogis (Acumulada)
fx = logistic.pdf(x, loc=location, scale=scale)
Fx = logistic.cdf(x, loc=location, scale=scale)

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
# Desenha a curva contínua da densidade (Formato de sino simétrico)
ax1.plot(x, fx, color="steelblue", linewidth=2)
# Preenche a área sob a curva para melhor visualização (alpha controla a transparência)
ax1.fill_between(x, fx, color="steelblue", alpha=0.15)

# Configurações de eixos e títulos dinâmicos
ax1.set_xlim(x_min, x_max)
ax1.set_ylim(0, max(fx) * 1.1)
ax1.set_title(f"Função de Densidade (PDF) - Logística(location={location}, scale={scale})", weight='bold', pad=15)
ax1.set_xlabel("Valor (x)")
ax1.set_ylabel("f(x)")

# ------------------------------------------------------------------------------
# Gráfico 2: CDF (Função de Distribuição Acumulada Contínua)
# ------------------------------------------------------------------------------
# Desenha a curva contínua acumulada (Formato de curva sigmoide suave em S)
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
# plt.savefig("figLogistica.jpeg", dpi=300, format="jpeg")

# Exibir os gráficos na tela (Equivalente ao x11() + plot)
plt.show()
