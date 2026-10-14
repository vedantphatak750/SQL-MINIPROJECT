export type Role = 'customer' | 'counter' | 'owner';
export type OrderType = 'Dine-in' | 'Takeaway';
export type OrderStatus = 'NEW' | 'ACCEPTED' | 'PREPARING' | 'READY' | 'COMPLETED';

export type Outlet = {
  id: string;
  name: string;
  shortName: string;
  address: string;
  hours: string;
  status: 'Open' | 'Busy' | 'Closing soon';
  tables: number;
  accent: string;
};

export type MenuItem = {
  id: string;
  name: string;
  category: 'Burgers' | 'Quick Bites' | 'Momos' | 'Fries' | 'Fried Rice' | 'Noodles' | 'Pizza' | 'Wraps' | 'Mocktails' | 'Shakes' | 'Beverages' | 'Desserts';
  description: string;
  price: number;
  image: string;
  featured?: boolean;
  enabled?: boolean;
  tag?: string;
};

export type OrderItem = {
  id: string;
  name: string;
  quantity: number;
  price: number;
  customization?: string;
  image?: string;
};

export type Order = {
  id: number;
  outletId: string;
  orderType: OrderType;
  table?: string;
  items: OrderItem[];
  total: number;
  status: OrderStatus;
  createdAt: string;
  customer: string;
};

export const outlets: Outlet[] = [
  {
    id: 'outlet-1',
    name: 'MH99 Burgers — Malad East',
    shortName: 'Malad East',
    address: '19 Church Street, Malad East',
    hours: '11:30 AM — 11:00 PM',
    status: 'Open',
    tables: 22,
    accent: '#F97316',
  },
  {
    id: 'outlet-2',
    name: 'MH99 Burgers — Andheri West',
    shortName: 'Andheri West',
    address: '48 Link Road, Andheri West',
    hours: '11:30 AM — 11:30 PM',
    status: 'Busy',
    tables: 34,
    accent: '#EF4444',
  },
  {
    id: 'outlet-3',
    name: 'MH99 Burgers — Powai',
    shortName: 'Powai',
    address: '2A Lake Boulevard, Powai',
    hours: '12:00 PM — 10:30 PM',
    status: 'Open',
    tables: 28,
    accent: '#F59E0B',
  },
];

export const menuItems: MenuItem[] = [
  {
    id: 'classic-smash',
    name: 'Classic Smash Burger',
    category: 'Burgers',
    description: 'Two crisp-edged patties, American cheese, pickles, house sauce.',
    price: 289,
    image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=1000&q=85',
    featured: true,
    enabled: true,
    tag: 'House favourite',
  },
  {
    id: 'firebird',
    name: 'The Firebird',
    category: 'Burgers',
    description: 'Crispy chicken, fermented chilli glaze, slaw, cooling ranch.',
    price: 319,
    image: 'https://images.unsplash.com/photo-1606755962773-d324e0a13086?auto=format&fit=crop&w=900&q=85',
    enabled: true,
    tag: 'New',
  },
  {
    id: 'green-room',
    name: 'Green Room',
    category: 'Burgers',
    description: 'Crispy potato, jalapeño relish, lettuce, smoked cheddar.',
    price: 269,
    image: 'https://images.unsplash.com/photo-1520072959219-c595dc870360?auto=format&fit=crop&w=900&q=85',
    enabled: true,
  },
  {
    id: 'double-down',
    name: 'Double Down',
    category: 'Burgers',
    description: 'Four smashed layers, onion jam, aged cheddar, black pepper mayo.',
    price: 389,
    image: 'https://images.unsplash.com/photo-1553979459-d2229ba7433b?auto=format&fit=crop&w=900&q=85',
    enabled: true,
    tag: 'Big energy',
  },
  {
    id: 'loaded-fries',
    name: 'Loaded Fries',
    category: 'Fries',
    description: 'Golden fries, cheese sauce, smoked brisket crumbs, scallions.',
    price: 179,
    image: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&w=900&q=85',
    featured: true,
    enabled: true,
  },
  {
    id: 'dirty-fries',
    name: 'Dirty Fries',
    category: 'Fries',
    description: 'Crispy fries tossed in house spice, garlic aioli and chives.',
    price: 149,
    image: 'https://images.unsplash.com/photo-1585109649139-366815a0d713?auto=format&fit=crop&w=900&q=85',
    enabled: true,
  },
  {
    id: 'corn-ribs',
    name: 'Charred Corn Ribs',
    category: 'Quick Bites',
    description: 'Sweet corn, lime butter, chilli salt and toasted sesame.',
    price: 159,
    image: 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?auto=format&fit=crop&w=900&q=85',
    enabled: true,
  },
  {
    id: 'cold-coffee',
    name: 'Cold Coffee',
    category: 'Beverages',
    description: 'Slow-steeped coffee, vanilla cream and a dark cocoa finish.',
    price: 159,
    image: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?auto=format&fit=crop&w=900&q=85',
    featured: true,
    enabled: true,
  },
  {
    id: 'orange-soda',
    name: 'Blood Orange Soda',
    category: 'Mocktails',
    description: 'Bright citrus, bitter orange and a little fizz over ice.',
    price: 129,
    image: 'https://images.unsplash.com/photo-1544145945-f90425340c7e?auto=format&fit=crop&w=900&q=85',
    enabled: true,
  },
  {
    id: 'black-tea',
    name: 'Black Tea Highball',
    category: 'Beverages',
    description: 'Cold-brewed Nilgiri tea, lemon peel and sparkling tonic.',
    price: 139,
    image: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?auto=format&fit=crop&w=900&q=85',
    enabled: true,
  },
  {
    id: 'soft-serve',
    name: 'Burnt Honey Soft Serve',
    category: 'Desserts',
    description: 'Vanilla soft serve, burnt honey caramel and sea salt crunch.',
    price: 169,
    image: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=900&q=85',
    enabled: true,
    tag: 'Sweet finish',
  },
  {
    id: 'brownie',
    name: 'Dark Chocolate Brownie',
    category: 'Desserts',
    description: 'Warm 70% chocolate brownie with coffee cream.',
    price: 189,
    image: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=900&q=85',
    enabled: true,
  },
  {
    id: 'pie',
    name: 'Salted Caramel Pie',
    category: 'Desserts',
    description: 'Buttery shortcrust, caramel custard and whipped mascarpone.',
    price: 199,
    image: 'https://images.unsplash.com/photo-1519915028121-7d3463d20b13?auto=format&fit=crop&w=900&q=85',
    enabled: true,
  },
  {
    id: 'spicy-momos',
    name: 'Tandoori Momos',
    category: 'Momos',
    description: 'Smoky paneer momos, mint chutney and a bright chilli glaze.',
    price: 189,
    image: 'https://images.unsplash.com/photo-1625398407796-82650a8c135f?auto=format&fit=crop&w=900&q=85',
    enabled: true,
    tag: 'Crowd pick',
  },
  {
    id: 'schezwan-rice',
    name: 'Schezwan Fried Rice',
    category: 'Fried Rice',
    description: 'Wok-tossed rice, charred vegetables, spring onion and house schezwan.',
    price: 229,
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=900&q=85',
    enabled: true,
  },
  {
    id: 'chilli-noodles',
    name: 'Chilli Garlic Noodles',
    category: 'Noodles',
    description: 'Slippery noodles, wok hei, garlic crisp and sesame greens.',
    price: 219,
    image: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=900&q=85',
    enabled: true,
  },
  {
    id: 'pepper-pizza',
    name: 'Pepper Paneer Pizza',
    category: 'Pizza',
    description: 'Charred crust, pepper paneer, mozzarella and smoked tomato sauce.',
    price: 329,
    image: 'https://images.unsplash.com/photo-1579751626657-72bc17010498?auto=format&fit=crop&w=900&q=85',
    enabled: true,
  },
  {
    id: 'crispy-wrap',
    name: 'Crispy Chicken Wrap',
    category: 'Wraps',
    description: 'Crunchy chicken, lettuce, pickled onions and chipotle mayo.',
    price: 249,
    image: 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?auto=format&fit=crop&w=900&q=85',
    enabled: true,
  },
  {
    id: 'mango-shake',
    name: 'Mango Cream Shake',
    category: 'Shakes',
    description: 'Alphonso mango, vanilla cream and a little cardamom.',
    price: 199,
    image: 'https://images.unsplash.com/photo-1579954115545-a95591f28bfc?auto=format&fit=crop&w=900&q=85',
    enabled: true,
  },
];

export const seedOrders: Order[] = [
  {
    id: 101,
    outletId: 'outlet-1',
    orderType: 'Takeaway',
    items: [
      { id: 'classic-smash', name: 'Classic Smash Burger', quantity: 1, price: 289 },
      { id: 'cold-coffee', name: 'Cold Coffee', quantity: 1, price: 159 },
    ],
    total: 470,
    status: 'READY',
    createdAt: '12:24 PM',
    customer: 'Aarav Menon',
  },
  {
    id: 102,
    outletId: 'outlet-2',
    orderType: 'Dine-in',
    table: '12',
    items: [
      { id: 'double-down', name: 'Double Down', quantity: 1, price: 389, customization: 'Extra cheese' },
      { id: 'dirty-fries', name: 'Dirty Fries', quantity: 1, price: 149 },
      { id: 'orange-soda', name: 'Blood Orange Soda', quantity: 2, price: 129 },
    ],
    total: 796,
    status: 'PREPARING',
    createdAt: '12:31 PM',
    customer: 'Mira Shah',
  },
  {
    id: 103,
    outletId: 'outlet-3',
    orderType: 'Dine-in',
    table: '04',
    items: [
      { id: 'green-room', name: 'Green Room', quantity: 1, price: 269 },
      { id: 'loaded-fries', name: 'Loaded Fries', quantity: 1, price: 179 },
    ],
    total: 448,
    status: 'NEW',
    createdAt: '12:42 PM',
    customer: 'Rohan Das',
  },
  {
    id: 98,
    outletId: 'outlet-2',
    orderType: 'Takeaway',
    items: [
      { id: 'firebird', name: 'The Firebird', quantity: 1, price: 319 },
      { id: 'soft-serve', name: 'Burnt Honey Soft Serve', quantity: 1, price: 169 },
    ],
    total: 488,
    status: 'COMPLETED',
    createdAt: '11:48 AM',
    customer: 'Nikhil George',
  },
  {
    id: 97,
    outletId: 'outlet-1',
    orderType: 'Dine-in',
    table: '08',
    items: [{ id: 'classic-smash', name: 'Classic Smash Burger', quantity: 2, price: 289 }],
    total: 578,
    status: 'COMPLETED',
    createdAt: '11:41 AM',
    customer: 'Diya Joseph',
  },
];

export const categories: MenuItem['category'][] = ['Burgers', 'Quick Bites', 'Momos', 'Fries', 'Fried Rice', 'Noodles', 'Pizza', 'Wraps', 'Mocktails', 'Shakes', 'Beverages', 'Desserts'];

export const statusSteps: OrderStatus[] = ['NEW', 'ACCEPTED', 'PREPARING', 'READY', 'COMPLETED'];

export const statusLabels: Record<OrderStatus, string> = {
  NEW: 'New order',
  ACCEPTED: 'Accepted',
  PREPARING: 'Preparing',
  READY: 'Ready for pickup',
  COMPLETED: 'Completed',
};

export const nextStatus: Partial<Record<OrderStatus, OrderStatus>> = {
  NEW: 'ACCEPTED',
  ACCEPTED: 'PREPARING',
  PREPARING: 'READY',
  READY: 'COMPLETED',
};
