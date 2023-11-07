using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Moderate.Servic.To.Peacee.RNModerateServicToPeacee
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNModerateServicToPeaceeModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNModerateServicToPeaceeModule"/>.
        /// </summary>
        internal RNModerateServicToPeaceeModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNModerateServicToPeacee";
            }
        }
    }
}
