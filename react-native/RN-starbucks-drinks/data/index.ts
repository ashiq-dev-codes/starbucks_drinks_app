import { ImageSourcePropType } from "react-native";

export type Coffee = {
  id: number;
  price: string;
  title: string;
  type: string;
  description: string;
  image: ImageSourcePropType;
};
export const starbucksData: Coffee[] = [
  {
    id: 1,
    title: "Chocolate Cream Chip Frappuccino",
    price: "$14",
    type: "Blended Beverage",
    description:
      "Rich mocha-flavored sauce blended with milk, chocolaty chips and ice. Topped with sweetened whipped cream and chocolate-flavored drizzle. This creation is the non-coffee alternative to our famous Java Chip Frappuccino. It is a decadent beverage for those who love the taste of chocolate – and lots of it. Rich, chocolaty chips punctuate a cool, refreshing blend of milk and mocha flavors. And in case that isn't enough chocolaty goodness for you, we finish our sweetened whipped cream topping with a deliciously sweet chocolate-flavored drizzle.",
    image: require("../assets/images/coffee/Chocolate Cream Chip Frappuccino.png"),
  },
  {
    id: 2,
    title: "Dark Mocha Frappuccino",
    price: "$14",
    type: "Blended Beverage",
    description:
      "For serious chocolate lovers: We blend dark cocoa with milk, ice and coffee for an extraordinarily chocolatey experience that's then topped with a swirl of whipped cream.",
    image: require("../assets/images/coffee/Dark Mocha Frappuccino.png"),
  },
  {
    id: 5,
    title: "Java Chip Frappuccino",
    price: "$14",
    type: "Blended Beverage",
    description:
      "Coffee with rich mocha-flavored sauce blended with milk, chocolaty chips and ice. Topped with sweetened whipped cream and chocolate-flavored drizzle. We created this wondrously decadent beverage for those who love the taste of chocolate – and lots of it – with their iced coffee. Rich, chocolaty chips punctuate a cool, refreshing blend of coffee and mocha flavors. And in case that isn't enough chocolaty goodness for you, we finish our sweetened whipped cream topping with a deliciously sweet chocolate-flavored drizzle.",
    image: require("../assets/images/coffee/Java Chip Frappuccino.png"),
  },
  {
    id: 6,
    title: "Green Tea Cream Frappuccino",
    price: "$14",
    type: "Blended Beverage",
    description:
      "A refreshing blend of sweetened matcha green tea, milk and ice. Topped with sweetened whipped cream. Although matcha tea is best known for its central role in the serene ritual known as the Japanese tea ceremony, tea drinkers all over the world have come to enjoy the gentle, uplifting taste of this finely-powdered green tea in their own way. We particularly like the way it blends with milk and ice in this refreshing Frappuccino® blended beverage. And we think you will too.",
    image: require("../assets/images/coffee/Green Tea Cream Frappuccino.png"),
  },
  {
    id: 7,
    title: "Vanilla Sweet Cream Cold Brew",
    price: "$14",
    type: "Coffee & Espresso",
    description:
      "Cold Brew topped with a delicate float of house-made vanilla sweet cream that cascades throughout the cup. We use a unique craft-brewing process to create a super smooth tasting coffee. While making our Cold Brew, the coffee never comes into contact with hot water. Instead, the coffee is slow-steeped in cool water for more than 10 hours and is handcrafted in small batches each day. To create our signature recipe, our team spent months experimenting with different brew times and coffee varietals. We specifically developed the Starbucks® Cold Brew Blend to heighten the rich, naturally sweet flavor created during the cold brewing process. The blend incorporates African and Latin American coffees.",
    image: require("../assets/images/coffee/Vanilla Sweet Cream Cold Brew.png"),
  },
  {
    id: 8,
    title: "Cold Brew",
    price: "$14",
    type: "Coffee & Espresso",
    description:
      "Slow-steeped, small-batch and super smooth. We use a unique craft-brewing process to create a super smooth tasting coffee. While making our Cold Brew, the coffee never comes into contact with hot water. Instead, the coffee is slow-steeped in cool water for 20 hours, no more no less and is handcrafted in small batches each day. To create our signature recipe, our team spent months experimenting with different brew times and coffee varietals. We specifically developed the Starbucks® Cold Brew Blend to heighten the rich, naturally sweet flavor created during the cold brewing process. The blend incorporates African and Latin American coffees.",
    image: require("../assets/images/coffee/Cold Brew.png"),
  },
];
