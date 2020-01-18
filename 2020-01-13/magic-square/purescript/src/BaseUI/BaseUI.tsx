import { Provider as StyletronProvider } from "styletron-react";
import { Client as Styletron } from "styletron-engine-atomic";
import { LightTheme, BaseProvider } from "baseui";
import * as React from "react";

export const ui_wrapper = (() => {
  const engine = new Styletron();

  return ({ children }: { children: React.ReactChildren }) => (
    <StyletronProvider value={engine}>
      <BaseProvider theme={LightTheme}>{children}</BaseProvider>
    </StyletronProvider>
  );
})();
