import { ITEM_HEIGHT, ITEM_WIDTH } from "@/constants";
import Colors from "@/constants/Colors";
import { Coffee as CoffeeType } from "@/data";
import React from "react";
import { Image } from "react-native";
import Animated, {
  interpolate,
  SharedValue,
  useAnimatedStyle,
} from "react-native-reanimated";

type Props = {
  index: number;
  scrollX: SharedValue<number>;
  item: CoffeeType;
};

const Coffee: React.FC<Props> = ({ scrollX, index, item }) => {
  const animatedStyle = useAnimatedStyle(() => {
    const inputRange = [
      (index - 2) * ITEM_WIDTH,
      (index - 1) * ITEM_WIDTH,
      index * ITEM_WIDTH,
    ];

    const outputRange = [0.5, 1, 0.5];

    return {
      transform: [
        {
          scale: interpolate(scrollX.value, inputRange, outputRange),
        },
      ],
    };
  });
  return (
    <Animated.View
      style={[
        {
          height: ITEM_HEIGHT,
          width: ITEM_WIDTH,
          alignItems: "center",
        },
        animatedStyle,
      ]}
    >
      <Image
        style={{
          width: "100%",
          height: "100%",
          shadowColor: Colors.black,
          shadowOffset: {
            width: 0,
            height: 10,
          },
          shadowRadius: 20,
          shadowOpacity: 0.7,
          overflow: "visible",
        }}
        resizeMode="contain"
        source={item.image}
      />
    </Animated.View>
  );
};
export default Coffee;
