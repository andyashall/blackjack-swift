import Foundation

public enum Rank : Int {
  case two = 2
  case three, four, five, six, seven, eight, nine, ten
  case jack, queen, king, ace
}

public enum Suit: String {
  case spades, hearts, diamonds, clubs
}

public struct Card {
  let rank: Rank
  let suit: Suit

  public init(rank: Rank, suit: Suit) {
    self.rank = rank
    self.suit = suit
  }

  public var description: String {
    return self.rank.description + " " + self.suit.description
  }

  public var value: Int {
    switch self.rank {
    case .ace: return 11
    case .jack: return 10
    case .queen: return 10
    case .king: return 10
    default:
      return self.rank.rawValue
    }
  }
}

extension Rank : CustomStringConvertible {
  public var description: String {
    switch self {
    case .ace: return "A"
    case .jack: return "J"
    case .queen: return "Q"
    case .king: return "K"
    default:
      return "\(rawValue)"
    }
  }
}

extension Suit : CustomStringConvertible {
  public var description: String {
    switch self {
    case .spades: return "♠︎"
    case .hearts: return "♡"
    case .diamonds: return "♢"
    case .clubs: return "♣︎"
    }
  }
}

typealias Deck = [Card]

func newDeck() -> Deck {
  let suits: [Suit] = [.spades, .hearts, .diamonds, .clubs]
  let ranks: [Rank] = [.two, .three, .four, .five, .six, .seven, .eight, .nine, .ten, .jack, .queen, .king, .ace]
  var cards: Deck = []
  for rank in ranks {
    for suit in suits {
      cards.append(Card(rank: rank, suit: suit))
    }
  }
  return cards
}

func shuffle(arr: Deck) -> Deck {
  var oArr = arr
  var nArr: Deck = []
  for _ in arr {
    let rand = Int(arc4random_uniform(UInt32(oArr.count)))
    nArr.append(oArr[rand])
    oArr.remove(at: rand)
  }
  return nArr
}

func sum(arr: Deck) -> Int {
  return arr.reduce(0, { x, y in
    x + y.value
  })
}

func printHand(hand: Deck) -> String {
  var h: String = " | "
  for c in  hand {
    h += c.description + " | "
  }
  return h
}

func addCard(deck: Deck, hand: Deck, other: Deck) -> (Deck, Deck, Deck) {
  return (Array(deck.suffix(deck.endIndex-1)), hand + [deck[0]], other)
}

func playDealer(deck: Deck, dealer: Deck, player: Deck) -> (Deck, Deck, Deck) {
  if (sum(arr: dealer) < 17) {
    return addCard(deck: deck, hand: dealer, other: player)
  } else {
    return (deck, dealer, player)
  }
}

func justDealer(deck: Deck, dealer: Deck, player: Deck) -> (Deck, Deck, Deck) {
  if (sum(arr: dealer) < 17) {
    let (nd, d, p) = addCard(deck: deck, hand: dealer, other: player)
    return justDealer(deck: nd, dealer: d, player: p)
  } else {
    return (deck, dealer, player)
  }
}

func declareWinner(dealer: Deck, player: Deck) {
  if (sum(arr: dealer) == sum(arr: player)) {
    print("Tie! on \(sum(arr: dealer))")
  } else if (sum(arr: dealer) > sum(arr: player)) {
    print("Dealer Wins! with \(sum(arr: dealer))")
  } else {
    print("You Win! with \(sum(arr: player))")
  }
}

func game(deck: Deck, dealer: Deck, player: Deck) {
  if (sum(arr: player) > 21) {
    print("You Busted! with \(sum(arr: player))")
  } else if (sum(arr: dealer) > 21) {
    print("Dealer Busted! with \(sum(arr: dealer))")
  } else {
    print("Your hand: \(printHand(hand: player))")
    print("Dealer hand: \(printHand(hand: dealer))")
    print("Hit or Stick?")
    let action = readLine()
    if action == "hit" || action == "Hit" {
      var (nd, p, d) = addCard(deck: deck, hand: player, other: dealer)
      (nd, d, p) = playDealer(deck: nd, dealer: d, player: p)
      game(deck: nd, dealer: d, player: p)
    } else if action == "stick" || action == "Stick" || action == "stay" || action == "Stay" {
      let (_, d, p) = justDealer(deck: deck, dealer: dealer, player: player)
      if (sum(arr: d) > 21) {
        print("Dealer Busted! with \(sum(arr: d))")
      } else {
        declareWinner(dealer: d, player: p)
      }
    } else {
      game(deck: deck, dealer: dealer, player: player)
    }
  }
}

let d = shuffle(arr: newDeck())

var (deck, player, dealer) = addCard(deck: d, hand: [], other: [])

(deck, dealer, player) = addCard(deck: deck, hand: dealer, other: player)

game(deck: deck, dealer: dealer, player: player)