# Outlet
outlets = ['Pizza Hut', 'Starbucks', 'KFC', 'Korean BBQ' ]

outlets.each do |outlet|
  Outlet.find_or_create_by(label: outlet)
end

# Menu
menu = ['Italian Pizza', 'Atlast Pizza', 'Family Set']

menu.each do |me|
  Menu.find_or_create_by(label: me)
end

# Section
sections = ['Classic Pizzas', 'Kid Set', 'Happy Set']

sections.each do |section|
  Section.find_or_create_by(label: section)
end

# Menu Section
MenuSection.find_or_create_by(menu: Menu.first, section: Section.first)
MenuSection.find_or_create_by(menu: Menu.last, section: Section.last)

# Items
items = ['Pizza', 'Fried Chicken', 'Americano']

items.each do |item|
  Item.find_or_create_by(sku: item)
end

# Item Section
item_sections = [{ item_id: Item.first.id, section_id: Section.first.id }, { item_id: Item.second.id, section_id: Section.first.id }, { item_id: Item.last.id, section_id: Section.last.id }]
SectionItem.find_or_create_by(item: Item.first, section: Section.first)
SectionItem.find_or_create_by(item: Item.last, section: Section.last)

# Modifier Group
ModifierGroup.find_or_create_by(label: 'Size of Pizza')
ModifierGroup.find_or_create_by(label: 'Size')

# Modifier
Modifier.find_or_create_by(modifier_group: ModifierGroup.first, label: '10" Pizza')
Modifier.find_or_create_by(modifier_group: ModifierGroup.last, label: '20" Pizza')
Modifier.find_or_create_by(modifier_group: ModifierGroup.last, label: 'Large')
Modifier.find_or_create_by(modifier_group: ModifierGroup.last, label: 'Small')

# Item Modifier Group
Item.all.each do |item|
  ItemModifierGroup.find_or_create_by(item: item, modifier_group: ModifierGroup.first)
end