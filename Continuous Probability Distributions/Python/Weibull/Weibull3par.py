import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import weibull_min

# O R nativo possui apenas a Weibull de 2 parâmetros (forma e escala). 
# Para adicionar o terceiro parâmetro — a localização (thres ou limite inferior, 
# que desloca o início da distribuição a partir do zero) —, nós aplicamos uma 
# transformação matemática simples diretamente nas funções padrão dweibull, 
# pweibull e qweibull, evitando a necessidade de instalar pacotes adicionais 
# pesados

# Versão Distribuição Weibull de 3 parâmetros

# 1. Definição dos parâmetros da Distribuição Weibull de 3 Parâmetros
shape = 2.0   # Parâmetro de forma (k ou c) - Controla a assimetria da curva
scale = 5.0   # Parâmetro de escala (lambda) - Controla a dispersão
thres = 10.0  # Parâmetro de localização (threshold) - Desloca a curva no eixo X

# Determinar os limites de visualização baseados nos quantis (0% até 99.9%)
# O ponto inicial exato da distribuição é o valor do próprio threshold (thres)
# weibull_min.ppf equivale à função qweibull do R
x_min = thres
x_max = thres + weibull_min.ppf(0.999, c=shape, scale=scale)

# 2. Suporte: Valores contínuos iniciando a partir do threshold (thres) até x_max
x = np.linspace(x_min, x_max, 1000)

# 3. Cálculo das funções exatas com o deslocamento nativo do SciPy (argumento loc)
# weibull_min.pdf equivale a dweibull
# weibull_min.cdf equivale a pweibull
fx = weibull_min.pdf(x, c=shape, loc=thres, scale=scale)
Fx = weibull_min.cdf(x, c=shape, loc=thres, scale=scale)

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
# Desenha a curva contínua da densidade
ax1.plot(x, fx, color="steelblue", linewidth=2)
# Preenche a área sob a curva para melhor visualização (alpha controla a transparência)
ax1.fill_between(x, fx, color="steelblue", alpha=0.15)

# Configurações de eixos e títulos dinâmicos
ax1.set_xlim(x_min, x_max)
ax1.set_ylim(0, max(fx) * 1.1)
ax1.set_title(f"Função de Densidade (PDF) - Weibull 3P(shape={shape}, scale={scale}, thres={thres})", weight='bold', pad=15)
ax1.set_xlabel("Valor (x)")
ax1.set_ylabel("f(x)")

# ------------------------------------------------------------------------------
# Gráfico 2: CDF (Função de Distribuição Acumulada Contínua)
# ------------------------------------------------------------------------------
# Desenha a curva contínua acumulada (Inicia exatamente no valor de thres)
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
# plt.savefig("figWeibull3P.jpeg", dpi=300, format="jpeg")

# Exibir os gráficos na tela (Equivalente ao x11() + plot)
plt.show()
