# Fractional

Represent precise rational numbers with the `Fractional<Number>` type. For convenience, `Fraction` is typealiased to `Fractional<Int>`.

```swift
let x: Fraction = (5 + 3) / (8 * 2) - 3 + (2 / -9)
print(x) // -> -21/8

func pow(base: Fraction, _ exponent: Int) -> Fraction {
    var result: Fraction = 1
    for _ in 1...abs(exponent) {
        result *= base
    }
    return exponent >= 0 ? result : result.reciprocal
}

let y: Fraction = 1/2
print(pow(y, 3)) // -> 1/8
```
