import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import uniform

# Versão Distribuição Uniforme Contínua

# 1. Definição dos parâmetros da Distribuição Uniforme Contínua
a = 2   # Limite inferior do suporte
b = 8   # Limite superior do suporte

# O SciPy usa a parametrização: loc = mínimo, scale = largura (b - a)
loc_param = a
scale_param = b - a

# Definir uma margem visual para mostrar a densidade antes de 'a' e depois de 'b'
margem = (b - a) * 0.2
x_min = a - margem
x_max = b + margem

# 2. Suporte: Valores contínuos incluindo a margem externa
x = np.linspace(x_min, x_max, 1000)

# 3. Cálculo das funções exatas
# uniform.pdf equivale a dunif (Densidade)
# uniform.cdf equivale a punif (Acumulada)
fx = uniform.pdf(x, loc=loc_param, scale=scale_param)
Fx = uniform.cdf(x, loc=loc_param, scale=scale_param)

# ==============================================================================
# Configuração da figura para os gráficos lado a lado (equivalente ao patchwork)
# ==============================================================================
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))

# Estilo visual limpo (equivalente ao theme_classic)
for ax in [ax1, ax2]:
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.tick_params(top=False, right=False)

# Criando a sequência de marcas nos eixos (breaks) pulando de 1 em 1
marcas_eixo_x = np.arange(int(round(x_min)), int(round(x_max)) + 1, 1)

# ------------------------------------------------------------------------------
# Gráfico 1: PDF (Função de Densidade de Probabilidade)
# ------------------------------------------------------------------------------
# Desenha a linha contínua que forma o retângulo da densidade uniforme
ax1.plot(x, fx, color="steelblue", linewidth=2)
# Preenche a área sob o retângulo para melhor visualização (alpha controla a transparência)
ax1.fill_between(x, fx, color="steelblue", alpha=0.15)

# Configurações de eixos e títulos dinâmicos
ax1.set_xlim(x_min, x_max)
ax1.set_xticks(marcas_eixo_x)
ax1.set_ylim(0, (1 / (b - a)) * 1.3)
ax1.set_title(f"Função de Densidade (PDF) - U({a}, {b})", weight='bold', pad=15)
ax1.set_xlabel("Valor (x)")
ax1.set_ylabel("f(x)")

# ------------------------------------------------------------------------------
# Gráfico 2: CDF (Função de Distribuição Acumulada Contínua)
# ------------------------------------------------------------------------------
# Desenha a linha contínua (0 antes de 'a', sobe em linha reta, estabiliza em 1 após 'b')
ax2.plot(x, Fx, color="darkorange", linewidth=2)

# Configurações de eixos e títulos
ax2.set_xlim(x_min, x_max)
ax2.set_xticks(marcas_eixo_x)
ax2.set_ylim(0, 1.05)
ax2.set_yticks(np.arange(0, 1.1, 0.2))  # Quebras de 0 até 1 de 0.2 em 0.2
ax2.set_title("Distribuição Acumulada (CDF)", weight='bold', pad=15)
ax2.set_xlabel("Valor (x)")
ax2.set_ylabel("F(x) = P(X <= x)")

# Ajusta o espaçamento para não cortar os textos
plt.tight_layout()

# Salvar como JPEG (Equivalente ao ggsave)
# plt.savefig("figUniformeContinua.jpeg", dpi=300, format="jpeg")

# Exibir os gráficos na tela (Equivalente ao x11() + plot)
plt.show()
