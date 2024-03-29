#6. Лабораторная работа: оценивание параметров геометрического броуновского движения
#1. Замоделировать процесс (10) для 𝑆0 = 100, 𝑎 = 0.5, 𝜎 = 0.8, √∆ = 0.01,𝑘 = 0, 1, . . . , 10^3
set.seed(123) # для воспроизводимости результатов
N = 1000 # число шагов
delta = 0.01 # шаг по времени
S0 = 100 # начальное значение S
a = 0.5 
sigma = 0.8 

t = seq(0, N*delta, delta)#вектор моментов наблюдений
length(t)
S = numeric(N+1)# моделирование процесса S
S[1] = S0
B = numeric(length(t))
B[1] = 0

for(k in 2:(N+1)) {B[k] = B[k-1] + rnorm(1, mean=0, sd=sigma) 
                   S[k] = S[1]*exp((a-sigma^2/2)*(k)*delta+sigma*B[k])
                   }

plot(t, S, type='l', col='gray', xlab='t', ylab='S(t)', main=' S(t)')
for (i in 2:(N+1)) {lines(t, S)}
# 2. Рассчитать оценки параметров броуновского движения (𝑎,𝜎^2) по наблюдениям процесса {𝑆𝑘∆}𝑘≥1.
# функция правдоподобия
for (k in 2:(N+1)) {S[k] = S[k-1] * exp((a - sigma^2/2) * delta + sigma * sqrt(delta) * rnorm(1))}
loglik = function(theta, data) {a = theta[1]
                                 sigma2 = theta[2]
                                 S = data
                                 n = length(S) - 1
                                 res = rep(0, n)
                                 for (i in 2:(n+1)) { res[i-1] = log(S[i]) - log(S[i-1]) - (a - sigma2/2) * delta}
                                 loglik = -n/2*log(2*pi) - n/2*log(sigma2*delta) - 1/(2*sigma2*delta)*sum(res^2)
                                 return(-loglik)}
# оценка параметров методом максимального правдоподобия
start = c(0.01, 0.01)
result = optim(start, loglik, data=S, method="L-BFGS-B", lower=c(0, 0), upper=c(Inf, Inf))

cat("Оценка параметра a:", result$par[1], "\n")
cat("Оценка параметра sigma^2:", result$par[2], "\n")

X = numeric(length(t))
for(i in 1:N){X[i] = log(S[i+1]) - log(S[i])}
M = mean(X)
D = var(X)*(N-1)/N
cat("Оценка параметра a:", M/delta + (D/delta)/2, "\n")
cat("Оценка параметра sigma^2:", D/delta, "\n")
