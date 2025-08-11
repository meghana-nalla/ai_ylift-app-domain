# components folder

Here you will find the individual components themselves. Components here must only be singular entities. Meaning they should never have other components inside them.
A component with another known component inside it should be inside the 'mixins' folder, not here.

This folder structure follows 

folder_component_name > component_index // meant for components that are expandable

folder_topic_name > [ component_name_file, ... , z-index ] // meant for components that are singular but share a common topic


If there is further complexity of a component, it inside the component_folder_name it
self along with another readme file explain

The simplest way to think about this is that a component should not
be importing another component from this folder. If it is, it should be in the mixins folder.

