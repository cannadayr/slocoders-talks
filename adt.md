# Type Systems:
    - A unified model to enforce constraints on compute operations (this is what makes it incredibly useful!).
    - A type might be semantic (cat, keyboard model, coffee shop), a digital representation (ieee float, integer 8, binary exchange), and likely other things.
    - Type systems are composed of types, and rules that apply to those types.
    1. Basic function header example:
    ```ocaml
        let pay = fun (cafe: cafe) (patron: patron) :transaction -> (* implementation left out! *)
        (* val pay : cafe -> patron -> transaction = <fun> *)
    ```
    2. Type parameter examples (they're like arguments but for types!):
    ```ocaml
        (* example of a type parameter in a function header *)
        let noop = fun (x: 'a) : 'a -> x;;
        (* example of a type parameter used in a type definition *)
        type 'a box = 'a
        let foo : int box = 1
        let bar : float box = 1.0
    ```
    3. Example of a contrived, very basic, type system:
    ```ocaml
        module type Currency = sig
            val convert : float -> float (* defines the interface *)
        end

        module Dollar : Currency = struct
            let convert c = c (* defines the implementation *)
        end

        module Euro : Currency = struct
            let convert c = 1.2 *. c (* additional implementation *)
        end

        let (f1,f2) = (Dollar.convert 10., Euro.convert 10.);;
        (*
        val f1 : float = 10.
        val f2 : float = 12.
        *)
    ```

# Composite Types (also called algebraic data types):
    - Tuple: Finite ordered list.
    - Enum: A value restricted to "one-of" multiple types.
    - Tuple's can be composed of sub-types!
    ```ocaml
        type transaction =
            {currency  : string;
             rate      : float;
             amount    : float;
             timestamp : int}
    ```
    - Enum's can be pattern matched against!
    ```ocaml
        type pet = Cat | Dog | Fish
        let my_pet : pet = Cat
        let noise = match my_pet with
            | Cat -> "meow"
            | Dog -> "ruff"
            | Fish -> "glub"
        (* val noise : string = "meow" *)
    ```

# Cool Tuple Stuff (also called relational algebra, or SQL)
    - Cartesian products: they enumerate tuples into collections.
    ```sql
        with foo as (
            values (1,2),(3,4)
        ),
        bar as (
            values ("b","c"),("d","e")
        )
        select * from foo,bar;

        -- 1|2|b|c
        -- 1|2|d|e
        -- 3|4|b|c
        -- 3|4|d|e
    ```
    - inner-joins: reduces the cartesian-product collection by specifying relationships that satisfy a constraint (in this case, indices that are equal).
    ```sql
        with foo as (
            values ("a",2),("b",4)
        ),
        bar as (
            values ("a",3),("a",4)
        )
        select * from foo,bar where foo."a" = bar."a";

        -- a|2|a|3
        -- a|2|a|4
    ```
    - group-bys: aggregates a table by specifying indices that form a unique subset, and applying an aggregation function to the unincluded indices (in this case, summing).
    ```sql
        with foo as (
            values (1,0),(1,1),(1,2)
        )
        select foo.column1, sum(foo.column2) from foo group by foo.column1;

        -- 1|3
    ```

# Cool Array Stuff (also called array theory)
    - Arrays are made of a shape, and a ravel.
    - The shape is a list of numbers, where each number is the length of an axis.
    - The ravel is a list of numbers, with a length equal to the axis lengths multiplied together.
    - The rank is the length of the shape.
    - example in BQN (funny symbols ahead):
    ```bqn
           foo ← 3‿3⥊↕9 # Some rank-2 array
        # ┌─
        # ╵ 0 1 2
        #   3 4 5
        #   6 7 8
        #         ┘

           ≢foo # Shape
        ⟨ 3 3 ⟩

           ⥊foo # Ravel
        ⟨ 0 1 2 3 4 5 6 7 8 ⟩

           ≢≢foo # Rank
        ⟨ 2 ⟩
    ```
    - Functions like indicing, reducing (also called folding), or scanning (also called the running-tally), can be applied to arrays at different ranks.
    - more examples in BQN:
    ```bqn
           1‿0⊑foo # Index by counting up the primary axis
        3

           0‿1⊑foo # Index by counting up the first leading axis
        1

           8⊑⥊foo # Index by counting up the ravel
        8

           (+´⎉1) foo # sum along the primary axis
        ⟨ 3 12 21 ⟩

           (+`⎉1) foo # scan-sum along the primary axis
        # ┌─
        # ╵ 0  1  3
        #   3  7 12
        #   6 13 21
        #           ┘
    ```

This talk was given for SLO County Coders, at StoryLabs San Luis Obispo, on June 19th 2023.
