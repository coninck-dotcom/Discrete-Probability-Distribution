import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import cauchy

# A distribuição de Cauchy é conhecida por suas caudas extremamente pesadas 
# (o que faz com que ela não possua média ou variância definidas). 
# Seus parâmetros são a localização (location, que dita o centro e o 
# pico da distribuição) e a escala (scale, que dita a dispersão). 
# Devido às caudas longas, o código usa os quantis de 1% e 99% para 
# cortar o eixo X de forma simétrica e focar no pico da curva.

# Versão Distribuição de Cauchy

# 1. Definição dos parâmetros da Distribuição de Cauchy
location = 0  # Parâmetro de localização (mediana/pico central)
scale = 1     # Parâmetro de escala (grau de dispersão) - Deve ser maior que 0

# Determinar limites adequados para focar no pico da distribuição
# Nota: Usamos 1% e 99% porque as caudas da Cauchy são infinitamente longas
# cauchy.ppf equivale à função qcauchy do R (Percent Point Function / Quantil)
x_min = cauchy.ppf(0.01, loc=location, scale=scale)
x_max = cauchy.ppf(0.99, loc=location, scale=scale)

# 2. Suporte: Valores contínuos de x_min até x_max
x = np.linspace(x_min, x_max, 1000)

# 3. Cálculo das funções exatas
# cauchy.pdf equivale a dcauchy (Densidade)
# cauchy.cdf equivale a pcauchy (Acumulada)
fx = cauchy.pdf(x, loc=location, scale=scale)
Fx = cauchy.cdf(x, loc=location, scale=scale)

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
# Desenha a curva contínua da densidade (Formato de sino com caudas pesadas)
ax1.plot(x, fx, color="steelblue", linewidth=2)
# Preenche a área sob a curva para melhor visualização (alpha controla a transparência)
ax1.fill_between(x, fx, color="steelblue", alpha=0.15)

# Configurações de eixos e títulos dinâmicos
ax1.set_xlim(x_min, x_max)
ax1.set_ylim(0, max(fx) * 1.1)
ax1.set_title(f"Função de Densidade (PDF) - Cauchy(location={location}, scale={scale})", weight='bold', pad=15)
ax1.set_xlabel("Valor (x)")
ax1.set_ylabel("f(x)")

# ------------------------------------------------------------------------------
# Gráfico 2: CDF (Função de Distribuição Acumulada Contínua)
# ------------------------------------------------------------------------------
# Desenha a curva contínua acumulada (Formato em S suave)
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
# plt.savefig("figCauchy.jpeg", dpi=300, format="jpeg")

# Exibir os gráficos na tela (Equivalente ao x11() + plot)
plt.show()
