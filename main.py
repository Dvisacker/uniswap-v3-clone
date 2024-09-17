import math
q96 = 2 ** 96
eth = 10**18
min_tick = -887272
max_tick = 887272

def liquidity(x,y):
    return x * y

def price(x, y):
    return y / x

def tick_price(tick_index):
    return 1.0001 ** tick_index

def tick_price_sqrt(tick_index):
    return 1.0001 ** (tick_index / 2)

def tick_index_from_tick_price(tick_price):
    return math.log(tick_price, 1.0001)

def price_to_sqrtp(price):
    return int(math.sqrt(price) * q96)

def price_to_tick(price):
    return math.floor(math.log(price, 1.0001))

def tick_to_sqrtp(tick_index):
    sqrt_price_x96 = q96 * (1.0001 ** tick_index)
    return sqrt_price_x96

def liquidity0(amount, p_a, p_b):
    if p_a > p_b:
        p_a, p_b = p_b,p_a 
    return (amount * (p_a * p_b) / q96) / (p_b - p_a)

def liquidity1(amount, p_a, p_b):
    if p_a > p_b:
        p_a, p_b = p_b,p_a 
    return amount * q96 / (p_b - p_a)

def liquidity(amount_0, amount_1, p_cur, p_a, p_b):
    liq0 = liquidity0(amount_0, p_cur, p_b)
    liq1 = liquidity1(amount_1, p_cur, p_a)
    return int(min(liq0, liq1))

def calc_amount_0(liq, p_a, p_b):
    if p_a > p_b:
        p_a, p_b = p_b,p_a 
    return int(liq * q96 * (p_b - p_a) / (p_b * p_a))

def calc_amount_1(liq, p_a, p_b):
    if p_a > p_b:
        p_a, p_b = p_b,p_a 
    return int(liq * (p_b - p_a) / q96)

def example_liquidity():
    current_price = 5000 # 1 eth = 5000 usdc
    sqrt_current = price_to_sqrtp(current_price)

    # the amount of tokens we deposit needs to be proportional to the price
    amount_eth = 1 * eth
    amount_usdc = current_price * amount_eth

    # we deposit liquidity between 4545 and 5500
    sqrt_low = price_to_sqrtp(4545)
    sqrt_high = price_to_sqrtp(5500)

    liq = liquidity(amount_eth, amount_usdc, sqrt_current, sqrt_low, sqrt_high)
    print(liq)

    


example_liquidity()




# def get_real_price(sqrt_price_x96, decimals_0, decimals_1):
#     p = (sqrt_price_x96 / Q96) ** 2
#     real_price = 1 / (p * decimals_0 / decimals_1)
#     return real_price


# def sqrtp_to_tick(sqrt_price_x96):
#     tick = 2 * math.log(sqrt_price_x96 / Q96) / math.log(1.0001)
#     return tick




# def example_get_real_price():
#     decimals_0 = 1e6
#     decimals_1 = 1e18
#     sqrt_price_x96 = 1610780447135348373753236403239924
#     real_price = get_real_price(sqrt_price_x96, decimals_0, decimals_1)
#     print(real_price)

# def example_get_tick():
#     sqrt_price_x96 = 1610780447135348373753236403239924
#     tick = get_tick(sqrt_price_x96)
#     print(tick)

# example_get_tick()
