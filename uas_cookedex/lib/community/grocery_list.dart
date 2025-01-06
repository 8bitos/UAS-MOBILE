import 'package:flutter/material.dart';

class GroceryListPage extends StatefulWidget {
  final List<Map<String, dynamic>> initialIngredients;

  const GroceryListPage({super.key, required this.initialIngredients});

  @override
  _GroceryListPageState createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  late List<Map<String, dynamic>> groceryItems;
  bool isDeleteMode = false;
  List<int> selectedItems = [];

  @override
  void initState() {
    super.initState();
    groceryItems = List.from(widget.initialIngredients); // Clone the list
  }

  void _addItem(String itemName) {
    if (itemName.isNotEmpty) {
      setState(() {
        groceryItems.add({"name": itemName, "checked": false});
      });
    }
  }

  void _toggleSelectionMode() {
    setState(() {
      isDeleteMode = !isDeleteMode;
      selectedItems.clear(); // Clear selections when toggling mode
    });
  }

  void _deleteSelectedItems() {
    setState(() {
      groceryItems = groceryItems
          .where((item) =>
              !selectedItems.contains(groceryItems.indexOf(item))) // Keep unselected
          .toList();
      selectedItems.clear();
      isDeleteMode = false;
    });
  }

  void _toggleCheck(int index) {
    setState(() {
      groceryItems[index]['checked'] = !groceryItems[index]['checked'];
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController itemController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Grocery",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDeleteMode ? Icons.close : Icons.delete,
              color: Colors.black,
            ),
            onPressed: _toggleSelectionMode,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Input Field to Add Items
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: itemController,
              decoration: InputDecoration(
                hintText: "Add new item",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add, color: Colors.orangeAccent),
                  onPressed: () {
                    _addItem(itemController.text);
                    itemController.clear();
                  },
                ),
              ),
            ),
          ),

          // Display the Grocery Items
          Expanded(
            child: ListView.builder(
              itemCount: groceryItems.length,
              itemBuilder: (context, index) {
                final item = groceryItems[index];
                final isSelected = selectedItems.contains(index);

                return GestureDetector(
                  onLongPress: () {
                    if (!isDeleteMode) {
                      setState(() {
                        isDeleteMode = true;
                        selectedItems.add(index);
                      });
                    }
                  },
                  onTap: () {
                    if (isDeleteMode) {
                      setState(() {
                        if (isSelected) {
                          selectedItems.remove(index);
                        } else {
                          selectedItems.add(index);
                        }
                      });
                    } else {
                      _toggleCheck(index);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.orange[100]
                          : Colors.white, // Highlight selected items
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Colors.orangeAccent
                            : Colors.grey[300]!,
                        width: 1.0,
                      ),
                    ),
                    child: ListTile(
                      leading: isDeleteMode
                          ? Checkbox(
                              value: isSelected,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    selectedItems.add(index);
                                  } else {
                                    selectedItems.remove(index);
                                  }
                                });
                              },
                            )
                          : Checkbox(
                              value: item['checked'],
                              onChanged: (value) => _toggleCheck(index),
                            ),
                      title: Text(
                        item['name'],
                        style: TextStyle(
                          decoration: item['checked']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: item['checked'] ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Delete Confirmation Button (in Delete Mode)
          if (isDeleteMode)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: selectedItems.isEmpty
                    ? null
                    : () {
                        _deleteSelectedItems();
                      },
                child: const Text(
                  "Delete Selected Items",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
