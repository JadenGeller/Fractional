public typealias Fraction = Fractional<Int>

private func gcd<Number: IntegerType>(var lhs: Number, var _ rhs: Number) -> Number {
	while rhs != 0 { (lhs, rhs) = (rhs, lhs % rhs) }
	return lhs
}
	
private func lcm<Number: IntegerType>(lhs: Number, _ rhs: Number) -> Number {
	return lhs * rhs / gcd(lhs, rhs)
}

private func reduce<Number: IntegerType>(numerator numerator: Number, denominator: Number) -> (numerator: Number, denominator: Number) {
	var divisor = gcd(numerator, denominator)
	if divisor < 0 { divisor *= -1 }
	guard divisor != 0 else { return (numerator: numerator, denominator: 0) }
	return (numerator: numerator / divisor, denominator: denominator / divisor)
}

public struct Fractional<Number: IntegerType> {
	/// The numerator of the fraction.
	public let numerator: Number
	
	/// The (always non-negative) denominator of the fraction.
	public let denominator: Number
	
	private init(numerator: Number, denominator: Number) {
		var (numerator, denominator) = reduce(numerator: numerator, denominator: denominator)
		if denominator < 0 { numerator *= -1; denominator *= -1 }
								
		self.numerator = numerator
		self.denominator = denominator
	}
    
    /// Create an instance initialized to `value`.
    public init(_ value: Number) {
        self.init(numerator: value, denominator: 1)
    }
}	

extension Fractional: Equatable {}
public func ==<Number: IntegerType>(lhs: Fractional<Number>, rhs: Fractional<Number>) -> Bool {
	return lhs.numerator == rhs.numerator && lhs.denominator == rhs.denominator
}

extension Fractional: Comparable {}
public func <<Number: IntegerType>(lhs: Fractional<Number>, rhs: Fractional<Number>) -> Bool {
    guard !lhs.isNaN && !rhs.isNaN else { return false }
    guard lhs.isFinite && rhs.isFinite else { return lhs.numerator < rhs.numerator }
	let (lhsNumerator, rhsNumerator, _) = Fractional.commonDenominator(lhs, rhs)
	return lhsNumerator < rhsNumerator
}

extension Fractional: Hashable {
	public var hashValue: Int {
		return numerator.hashValue ^ denominator.hashValue
	}
}

extension Fractional: Strideable {
	private static func commonDenominator(lhs: Fractional, _ rhs: Fractional) -> (lhsNumerator: Number, rhsNumberator: Number, denominator: Number) {
		let denominator = lcm(lhs.denominator, rhs.denominator)
		let lhsNumerator = lhs.numerator * (denominator / lhs.denominator)
		let rhsNumerator = rhs.numerator * (denominator / rhs.denominator)
		
		return (lhsNumerator, rhsNumerator, denominator)
	}
	
	public func advancedBy(n: Fractional) -> Fractional {
		let (selfNumerator, nNumerator, commonDenominator) = Fractional.commonDenominator(self, n)
		return Fractional(numerator: selfNumerator + nNumerator, denominator: commonDenominator)
	}
	
	public func distanceTo(other: Fractional) -> Fractional {
		return other.advancedBy(-self)
	}
}

extension Fractional: IntegerLiteralConvertible {
	public init(integerLiteral value: Number) {
		self.init(value)
	}
}

extension Fractional: SignedNumberType {}
public prefix func -<Number: IntegerType>(value: Fractional<Number>) -> Fractional<Number> {
	return Fractional(numerator: -1 * value.numerator, denominator: value.denominator)
}

extension Fractional {
	/// The reciprocal of the fraction.
	public var reciprocal: Fractional {
		get {
			return Fractional(numerator: denominator, denominator: numerator)
		}
	}
	
	/// `true` iff `self` is neither infinite nor NaN
	public var isFinite: Bool {
		return denominator != 0 
	}
	
	/// `true` iff the numerator is zero and the denominator is nonzero 
	public var isInfinite: Bool {
		return denominator == 0 && numerator != 0
	}
	
	/// `true` iff both the numerator and the denominator are zero
	public var isNaN: Bool {
		return denominator == 0 && numerator == 0
	}
	
	/// The positive infinity.
	public static var infinity: Fractional {
		return 1 / 0
	}
	
	/// Not a number.
	public static var NaN: Fractional {
		return 0 / 0
	}
}

extension Fractional: CustomStringConvertible {
	public var description: String {
		guard !isNaN else { return "NaN" }
		guard !isInfinite else { return (self >= 0 ? "+" : "-") + "Inf" }
		
		switch denominator {
		case 1: return "\(numerator)"
		default: return "\(numerator)/\(denominator)"
		}
	}
}
	
/// Add `lhs` and `rhs`, returning a reduced result.
public func +<Number: IntegerType>(lhs: Fractional<Number>, rhs: Fractional<Number>) -> Fractional<Number> {
	guard !lhs.isNaN && !rhs.isNaN else { return .NaN }
	guard lhs.isFinite && rhs.isFinite else {
		switch (lhs >= 0, rhs >= 0) {
		case (false, false): return -.infinity
		case (true, true):   return .infinity
		default:			 return .NaN
		}
	}
	return lhs.advancedBy(rhs)
}
public func +=<Number: IntegerType>(inout lhs: Fractional<Number>, rhs: Fractional<Number>) {
    lhs = lhs + rhs
}

/// Subtract `lhs` and `rhs`, returning a reduced result.
public func -<Number: IntegerType>(lhs: Fractional<Number>, rhs: Fractional<Number>) -> Fractional<Number> {
	return lhs + -rhs
}
public func -=<Number: IntegerType>(inout lhs: Fractional<Number>, rhs: Fractional<Number>) {
    lhs = lhs - rhs
}

/// Multiply `lhs` and `rhs`, returning a reduced result.
public func *<Number: IntegerType>(lhs: Fractional<Number>, rhs: Fractional<Number>) -> Fractional<Number> {
	let swapped = (Fractional(numerator: lhs.numerator, denominator: rhs.denominator), Fractional(numerator: rhs.numerator, denominator: lhs.denominator))
	return Fractional(numerator: swapped.0.numerator * swapped.1.numerator, denominator: swapped.0.denominator * swapped.1.denominator)
}
public func *=<Number: IntegerType>(inout lhs: Fractional<Number>, rhs: Fractional<Number>) {
    lhs = lhs * rhs
}

/// Divide `lhs` and `rhs`, returning a reduced result.
public func /<Number: IntegerType>(lhs: Fractional<Number>, rhs: Fractional<Number>) -> Fractional<Number> {
	return lhs * rhs.reciprocal
}
public func /=<Number: IntegerType>(inout lhs: Fractional<Number>, rhs: Fractional<Number>) {
    lhs = lhs / rhs
}

extension Double {
	/// Create an instance initialized to `value`.
	init<Number: IntegerType>(_ value: Fractional<Number>) {
		self.init(Double(value.numerator.toIntMax()) / Double(value.denominator.toIntMax()))
	}
}

extension Float {
	/// Create an instance initialized to `value`.
	init<Number: IntegerType>(_ value: Fractional<Number>) {
		self.init(Float(value.numerator.toIntMax()) / Float(value.denominator.toIntMax()))
	}
}
