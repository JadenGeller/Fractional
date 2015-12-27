# Fractional

Represent precise rational numbers with the `Fractional<Number>` type. For convenience, `Fraction` is typealiased to `Fractional<Int>`.

```swift
func pow(base: Fraction, _ exponent: Int) -> Fraction {
    var result: Fraction = 1
    for _ in 1...abs(exponent) {
        result *= base
    }
    return exponent >= 0 ? result : result.reciprocal
}

let x: Fraction = 1/2
print(pow(x, 3)) // -> 1/8
```
