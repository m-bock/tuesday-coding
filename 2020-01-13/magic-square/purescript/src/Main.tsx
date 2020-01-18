import * as ReactDOM from "react-dom";

export const mountApp = callback => () => {
  const mount = () => {
    const elementApp = window.document.createElement("div");

    if (module.hot) {
      module.hot.accept();

      module.hot.dispose(() => {
        ReactDOM.unmountComponentAtNode(elementApp);
        elementApp.remove();
      });
    }

    window.document.body.append(elementApp);

    window.document.removeEventListener("DOMContentLoaded", mount);

    callback(elementApp)();
  };

  window.document.addEventListener("DOMContentLoaded", mount);
};
