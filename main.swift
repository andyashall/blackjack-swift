import Foundation

var suit: [String] = ["2","3","4","5","6","7","8","9","10","Jack","Queen","King","Ace"]
var deck: [String] = suit + suit + suit + suit

func cardValue(card: String) -> Int {
  switch card {
    case "Jack",
         "Queen",
         "King":
      return 10
    case "Ace":
      return 11
    default:
      let a: Int? = Int(card)
      return a!
  }
}

func sum(arr: [String]) -> Int {
  return arr.reduce(0, { x, y in
    x + cardValue(card: y)
  })
}

func shuffle(arr: [String]) -> [String] {
  var oArr = arr
  var nArr: [String] = []
  for _ in arr {
    let rand = Int(arc4random_uniform(UInt32(oArr.count)))
    nArr.append(oArr[rand])
    oArr.remove(at: rand)
  }
  return nArr
}

func playDealer(deck: [String], d: [String], p: [String]) -> (String], [String], [String]) {
  if sum(arr: d) < 17 {
    return (Array(deck.suffix(deck.endIndex-1)), d + [deck[0]], p)
  } else {
    return (deck, d, p)
  }
}

func game(deck: [String], d: [String], p: [String]) -> () {

  let player = sum(arr: np)
  let dealer = sum(arr: nd)

  if player > 21 {
    print("Your Bust boi!")
    return
  }

  if dealer > 21 {
    print("Dealer Bust boi!")
    return
  }

  print("Your hand: \(player)")
  print("Dealer hand: \(dealer)")

  let action = readLine()
  if action == "hit" || action == "Hit" {
    var nd
    var np
    if dealer < 17 {
      nd = d + [deck[0]]
      np = p + [deck[1]]
    } else {
      nd = d
      np = p + [deck[0]]
    }
    game(deck: Array(deck.suffix(deck.endIndex-2)), d: nd, p: np)
  } else if action == "stick" || action == "Stick" || action == "stay" || action == "Stay" {
    if dealer < 17 {
      
    } else {
      if dealer == player {
        print("Tie!")
      } else if player > dealer {
        print("You Win!")
      } else {
        print("You Loose!")
      } 
    }
  } else {
    print("what?")
  }
}

game(deck: shuffle(arr: deck), d: [], p: [])