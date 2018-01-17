//: Playground - noun: a place where people can play
//******* GENERIC THE LIFE SAVER ************//

/*
 Generic code enables you to write flexible, reusable functions and types that can work with any type, subject to requirements that you define. You can write code that avoids duplication and expresses its intent in a clear, abstracted manner.
 */

var name = "anurag"
var lastName = "yadav"

var int1 = 1
var int2 = 2

func swapTwoString(name:inout String, lastName:inout String) {
  let tempString = name
      name = lastName
      lastName = tempString
}

  swapTwoString(name: &name, lastName: &lastName)

print("first is now \(name), and lastName is now \(lastName)")

/*
 We can use this with different-2 type like double,int etc.
 Note : Swift is a type-safe language, and doesn’t allow (for example) a variable of type String and a variable of type Double to swap values with each other. Attempting to do so results in a compile-time error.
 */

// GENERIC FUNCTION //


 /**
 Swap two value of any type.
 
 In the swapTwoValues(_:_:) example above, the placeholder type T is an example of a type parameter. Type parameters specify and name a placeholder type, and are written immediately after the function’s name, between a pair of matching angle brackets (such as <T>).
 */

func swapTwoValue<T>(name:inout T, lastName:inout T) {
  let tempString = name
  name = lastName
  lastName = tempString
}

 // let's print random types

swapTwoValue(name: &int2, lastName: &int1)
swapTwoValue(name: &name, lastName: &lastName)

print("int1 is now \(int1), and int2 is now \(int2)")
print("first is now \(name), and lastName is now \(lastName)")

// ******** Naming Type Parameters **********//
//In most cases, type parameters have descriptive names, such as Key and Value in Dictionary<Key, Value> and Element in Array<Element>, which tells the reader about the relationship between the type parameter and the generic type or function it’s used in. However, when there isn’t a meaningful relationship between them, it’s traditional to name them using single letters such as T, U, and V, such as T in the swapTwoValues(_:_:) function above.

//e.g func swapTwoValue<MyParameterType>(name name:inout MyParameterType, lastName lastName:inout MyParameterType) {}


//********** Generic Types *************//

// SWIFT allow us to write our own generic type,These are custom classes, structures, and enumerations that can work with any type, in a similar way to Array and Dictionary.
//let's take an example of STACK which mean the item insterted first would be deleted first by peroforming PUSH and POP

struct IntStack {
  
  var items = [Int]()
  
  mutating func push(item: Int) {
    items.append(item)
  }
  
  mutating func pop() -> Int {
    
    return items.removeLast()
  }
  
}

// In This example the IntStack type shown above can only be used with Int values, however. It would be much more useful to define a generic Stack class, that can manage a stack of any type of value. let's define a generic version

struct Stack<Element>{
  
  var items = [Element]()
  
  mutating func push(item: Element) {
    items.append(item)
  }
  
  mutating func pop() -> Element {
    
    return items.removeLast()
  }
}

// So now we can push any value and pop any value we want e.g string

var stringStruck = Stack<String>()

// Here we defined type string
  stringStruck.push(item: "one")  // Add value into stack
  stringStruck.push(item: "two")
  stringStruck.push(item: "three")

  print(stringStruck.items)

// Let's perform POP, it removed last inserted object
  print(stringStruck.pop())

// TODO: Please try to create generic type of enum

//// *************** Extending a Generic Type ***************////

// When you extend a generic type, you don’t provide a type parameter list as part of the extension’s definition. Instead, the type parameter list from the original type definition is available within the body of the extension, and the original type parameter names are used to refer to the type parameters from the original definition.

extension Stack {
  
  var topItem: Element? {
    
    return items.isEmpty ? nil : items[items.count - 1]
  }
}

if let topElement = stringStruck.topItem {
  print(topElement) // it will print two
}


/// ********  Type Constraints
// Type constraints specify that a type parameter must inherit from a specific class, or conform to a particular protocol or protocol composition.

//Type Constraint Syntax  : The basic syntax for type constraints on a generic function is shown below (although the syntax is the same for generic types):

/*
func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
  // function body goes here
}
*/

// e.g of Type Constraints **

func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
  for (index, value) in array.enumerated() {
    if value == valueToFind {
      return index
    }
  }
  return nil
}

 let countryName = ["INDIA", "USA", "JAPAN", "CANADA", "CHINA", "RUSSIA", "MEXICO"]

if let index = findIndex(ofString: "CANADA", in: countryName) {
  
  print(index)
}

// Let's use generic now like T

func findIndex <T: Equatable>(of valueToFind: T, in array: [T]) -> Int? {
  for (index, value) in array.enumerated() {
    if value == valueToFind { // This line should throw a compler error because Not every type in swift can be compared with the equal to operator, so we will confirm this function to Equatable protocol, The Swift standard library defines a protocol called Equatable, which requires any conforming type to implement the equal to operator (==) and the not equal to operator (!=) to compare any two values of that type. All of Swift’s standard types automatically support the Equatable protocol.
      return index
    }
  }
  return nil
}

let doubleIndex = findIndex(of: 9.3, in: [3.14159, 0.1, 0.25]) // Now we can compare all type by confirming T to Equatbel protocol

print(doubleIndex) // it print nil

///*************  Associated Types
// When defining a protocol, it’s sometimes useful to declare one or more associated types as part of the protocol’s definition. An associated type gives a placeholder name to a type that is used as part of the protocol. The actual type to use for that associated type isn’t specified until the protocol is adopted. Associated types are specified with the associatedtype keyword.

//***E.g let's create a protocol , which declares an associated type called Name:

protocol Countries {
  
  associatedtype Name
  
  mutating func appened(_ name: Name)  // appened or add name of country
  var count: Int { get }  // access count of the Countries
  subscript(index: Int) -> Name { get } // retrieve country name by passing the index
}

// Let's use this Protocol
//

//IntStack specifies that for this implementation of Countries, the appropriate Item to use is a type of Int. The definition of typealias Item = Int turns the abstract type of Item into a concrete type of Int for this implementation of the Countries protocol.

// Here’s a version of the nongeneric IntStack type from earlier, adapted to conform to the Countries protocol:


extension IntStack: Countries {
  
  var count: Int {
    return items.count
  }
  
 mutating func appened(_ name: Int) {
    self.push(item: name)
  }
  
  subscript(index: Int) -> Int {
    return items[index]
  }
}

//Thanks to Swift’s type inference, you don’t actually need to declare a concrete Item of Int as part of the definition of IntStack. Because IntStack conforms to all of the requirements of the Countries protocol, Swift can infer the appropriate Item to use, simply by looking at the type of the append(_:) method’s item parameter and the return type of the subscript. Indeed, if you delete the typealias Item = Int line from the code above, everything still works, because it’s clear what type should be used for Item.

//let's make the generic Stack type conform to the Countries protocol, This time the type parameter Element is used as the type of the append(_:) method’s item parameter and the return type of the subscript. Swift can therefore infer that Element is the appropriate type to use as the Item for this particular container.



extension Stack: Countries {
  
  var count: Int {
    
    return items.count
  }
  
mutating  func appened(_ name: Element) {
    self.push(item: name)
  }
  
  subscript(index: Int) -> Element {
  
  return items[index]
  }
}









