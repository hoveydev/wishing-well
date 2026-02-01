# Screen Components Architecture Proposal

## 🎯 Recommended Structure

```
lib/screens/add_wisher/
├── components/              # Screen-specific reusable components
│   ├── add_wisher_buttons.dart      # Move from lib/screens/add_wisher/
│   ├── add_wisher_description.dart # Move from lib/screens/add_wisher/
│   └── add_wisher_header.dart     # Move from lib/screens/add_wisher/
├── add_wisher_info_screen.dart    # Full screen using components
└── add_wisher_view_model.dart     # ViewModel for the screen
```

## ✅ Benefits of This Approach

### **1. Localization Property Pattern**
```dart
// In screen components - accept localization via properties
class AddWisherButtons extends StatelessWidget {
  const AddWisherButtons({
    required this.onAddFromContacts,
    required this.onAddManually,
    this.addFromContactsText,    // Optional: override default
    this.addManuallyText,        // Optional: override default
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        AppButton.label(
          label: addFromContactsText ?? l10n.addFromContacts,
          onPressed: onAddFromContacts,
        ),
        AppButton.label(
          label: addManuallyText ?? l10n.addManually,
          onPressed: onAddManually,
        ),
      ],
    );
  }
}
```

### **2. Test Helper Integration**
```dart
// In tests - now works correctly!
testWidgets('AddWisherButtons renders correctly', (WidgetTester tester) async {
  await tester.pumpWidget(
    createComponentTestWidget( // ✅ Components use this
      AddWisherButtons(
        addFromContactsText: 'Add From Contacts', // Optional override
        addManuallyText: 'Add Manually',           // Optional override
        onAddFromContacts: () {},
        onAddManually: () {},
      ),
    ),
  );
  await TestHelpers.pumpAndSettle(tester);
  
  TestHelpers.expectTextOnce('Add From Contacts');
  TestHelpers.expectTextOnce('Add Manually');
});
```

### **3. Consistent Pattern Application**
```dart
// Other screen components follow same pattern
class AddWisherDescription extends StatelessWidget {
  const AddWisherDescription({
    this.descriptionText, // Optional override
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Text(
      descriptionText ?? l10n.addWisherDescription,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
```

## 🔄 Migration Steps

### **Phase 1: Create Directory Structure**
```bash
mkdir -p lib/screens/add_wisher/components
```

### **Phase 2: Move & Refactor Files**
```bash
mv lib/screens/add_wisher/add_wisher_buttons.dart lib/screens/add_wisher/components/
mv lib/screens/add_wisher/add_wisher_description.dart lib/screens/add_wisher/components/
mv lib/screens/add_wisher/add_wisher_header.dart lib/screens/add_wisher/components/
```

### **Phase 3: Update Components**
- Add optional localization properties to each component
- Keep AppLocalizations.of(context) usage (it's correct!)
- Remove hardcoded strings

### **Phase 4: Update Info Screen**
- Import components from new `components/` subdirectory
- Pass localization properties when needed

### **Phase 5: Update Tests**
- Tests now work with createComponentTestWidget() ✅
- All localization properly handled via context

## 🎯 Final Architecture Benefits

✅ **Logical Organization**: All add_wisher code grouped together  
✅ **Reusability**: Components can be used by other screens  
✅ **Testing Clarity**: Clear separation of component vs screen tests  
✅ **Localization**: Proper pattern with optional overrides  
✅ **Discoverability**: Developers know where to find related code  
✅ **Consistency**: Follows established screen component pattern  

---

**This architecture solves both the categorization issue AND preserves localization requirements! 🚀**