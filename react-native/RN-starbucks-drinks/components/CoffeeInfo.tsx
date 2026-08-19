import { INFO_ITEM_HIEGHT } from "@/constants";
import Colors from "@/constants/Colors";
import Font from "@/constants/Font";
import FontSize from "@/constants/FontSize";
import Spacing from "@/constants/Spacing";
import { Coffee } from "@/data";
import React from "react";
import { Text, View } from "react-native";

type Props = {
  item: Coffee;
};

const CoffeeInfo: React.FC<Props> = ({ item }) => {
  return (
    <View
      key={item.id}
      style={{
        paddingHorizontal: Spacing * 2,
        paddingVertical: Spacing * 5,
        height: INFO_ITEM_HIEGHT - Spacing * 7,
      }}
    >
      <Text
        style={{
          fontSize: FontSize.xLarge,
          fontFamily: Font["poppins-bold"],
        }}
      >
        {item.price}
      </Text>
      <Text
        style={{
          fontSize: FontSize.large,
          fontFamily: Font["poppins-semiBold"],
          marginVertical: Spacing,
        }}
        numberOfLines={2}
      >
        {item.title}
      </Text>
      <Text
        style={{
          fontSize: FontSize.small,
          fontFamily: Font["poppins-regular"],
          color: Colors.lightText,
        }}
        numberOfLines={7}
      >
        {item.description}
      </Text>
    </View>
  );
};

export default CoffeeInfo;
