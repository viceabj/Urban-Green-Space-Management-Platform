;; Project Proposals Contract

(define-map proposals
  { proposal-id: uint }
  {
    title: (string-ascii 100),
    description: (string-utf8 1000),
    space-id: uint,
    budget: uint,
    proposer: principal,
    status: (string-ascii 20),
    votes-for: uint,
    votes-against: uint
  }
)

(define-data-var proposal-nonce uint u0)

(define-public (create-proposal
  (title (string-ascii 100))
  (description (string-utf8 1000))
  (space-id uint)
  (budget uint))
  (let
    ((new-id (+ (var-get proposal-nonce) u1)))
    (map-set proposals
      { proposal-id: new-id }
      {
        title: title,
        description: description,
        space-id: space-id,
        budget: budget,
        proposer: tx-sender,
        status: "active",
        votes-for: u0,
        votes-against: u0
      }
    )
    (var-set proposal-nonce new-id)
    (ok new-id)
  )
)

(define-read-only (get-proposal (proposal-id uint))
  (map-get? proposals { proposal-id: proposal-id })
)

(define-public (vote-on-proposal (proposal-id uint) (vote bool))
  (let
    ((proposal (unwrap! (map-get? proposals { proposal-id: proposal-id }) (err u404))))
    (asserts! (is-eq (get status proposal) "active") (err u403))
    (map-set proposals
      { proposal-id: proposal-id }
      (merge proposal
        {
          votes-for: (if vote (+ (get votes-for proposal) u1) (get votes-for proposal)),
          votes-against: (if vote (get votes-against proposal) (+ (get votes-against proposal) u1))
        }
      )
    )
    (ok true)
  )
)

(define-public (close-proposal (proposal-id uint))
  (let
    ((proposal (unwrap! (map-get? proposals { proposal-id: proposal-id }) (err u404))))
    (asserts! (is-eq tx-sender (get proposer proposal)) (err u403))
    (map-set proposals
      { proposal-id: proposal-id }
      (merge proposal { status: "closed" })
    )
    (ok true)
  )
)

