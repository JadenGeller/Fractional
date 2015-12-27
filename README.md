# Fractional

Represent precise rational numbers with the `Fractional<Number>` type. For convenience, `Fraction` is typealiased to `Fractional<Int>`.

Fractions are `IntegerLiteralConvertible`, so they can be written as simply as `1/2 as Fraction`.

```swift
let x: Fraction = (5 + 1) / (8 * 2) - 3
print(x) // -> -21/8
```

Fractions can also be created from an `Int`.
```swift
let x = 5
let y = 8
let z = Fraction(x) / Fraction(y)
```

As you'd expect, you can add, subtract, multiply, and divide fractions. Further, they support some common operations such as `reciprocal`.
```swift
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

Upon division by zero, a fraction might become infinity or NaN.
```swift
print(1/0 as Fraction)  // -> +Inf
print(-1/0 as Fraction) // -> -Inf
print(0/0 as Fraction)  // -> NaN
```

You can easily check if a fraction is finite, infinite, or NaN as well with the appropriately named `isFinite`, `isInfinite`, and `isNaN` properties.
