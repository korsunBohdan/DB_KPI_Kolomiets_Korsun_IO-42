-- CreateTable
CREATE TABLE "categories" (
    "category_id" SERIAL NOT NULL,
    "category_name" VARCHAR(40) NOT NULL,

    CONSTRAINT "categories_pkey" PRIMARY KEY ("category_id")
);

-- CreateTable
CREATE TABLE "clients" (
    "client_id" SERIAL NOT NULL,
    "first_name" VARCHAR(30) NOT NULL,
    "last_name" VARCHAR(30) NOT NULL,
    "client_phone" CHAR(12) NOT NULL,
    "client_email" CHAR(64) NOT NULL,

    CONSTRAINT "clients_pkey" PRIMARY KEY ("client_id")
);

-- CreateTable
CREATE TABLE "employee" (
    "employee_id" SERIAL NOT NULL,
    "first_name" VARCHAR(30) NOT NULL,
    "last_name" VARCHAR(50) NOT NULL,
    "employee_position" VARCHAR(64) NOT NULL,
    "employee_phone" CHAR(12) NOT NULL,
    "employee_email" CHAR(64) NOT NULL,

    CONSTRAINT "employee_pkey" PRIMARY KEY ("employee_id")
);

-- CreateTable
CREATE TABLE "order_items" (
    "order_item_id" SERIAL NOT NULL,
    "order_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 0,
    "sale_price" DECIMAL(10,2) NOT NULL,

    CONSTRAINT "order_items_pkey" PRIMARY KEY ("order_item_id")
);

-- CreateTable
CREATE TABLE "orders" (
    "order_id" SERIAL NOT NULL,
    "client_id" INTEGER NOT NULL,
    "employee_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "orders_pkey" PRIMARY KEY ("order_id")
);

-- CreateTable
CREATE TABLE "products" (
    "product_id" SERIAL NOT NULL,
    "category_id" INTEGER NOT NULL,
    "product_name" VARCHAR(60) NOT NULL,
    "product_description" TEXT,
    "product_price" DECIMAL(10,2) NOT NULL DEFAULT 0.00,

    CONSTRAINT "products_pkey" PRIMARY KEY ("product_id")
);

-- CreateTable
CREATE TABLE "stock_balances" (
    "stock_id" SERIAL NOT NULL,
    "warehouse_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "last_update" DATE NOT NULL DEFAULT CURRENT_DATE,
    "quantity" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "stock_balances_pkey" PRIMARY KEY ("stock_id")
);

-- CreateTable
CREATE TABLE "supplier" (
    "supplier_id" SERIAL NOT NULL,
    "company_name" VARCHAR(40) NOT NULL,
    "contact_person" VARCHAR(80) NOT NULL,
    "contact_phone" CHAR(12) NOT NULL,

    CONSTRAINT "supplier_pkey" PRIMARY KEY ("supplier_id")
);

-- CreateTable
CREATE TABLE "supply_deliver" (
    "supply_delivery_id" SERIAL NOT NULL,
    "supplier_id" INTEGER NOT NULL,
    "employee_id" INTEGER NOT NULL,
    "warehouse_id" INTEGER NOT NULL,
    "delivery_date" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "supply_deliver_pkey" PRIMARY KEY ("supply_delivery_id")
);

-- CreateTable
CREATE TABLE "supply_items" (
    "supply_item_id" SERIAL NOT NULL,
    "supply_delivery_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "purchase_price" DECIMAL(10,2) NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "supply_items_pkey" PRIMARY KEY ("supply_item_id")
);

-- CreateTable
CREATE TABLE "warehouse" (
    "warehouse_id" SERIAL NOT NULL,
    "warehouse_name" VARCHAR(25) NOT NULL,
    "city" VARCHAR(30) NOT NULL,
    "street_address" VARCHAR(50) NOT NULL,

    CONSTRAINT "warehouse_pkey" PRIMARY KEY ("warehouse_id")
);

-- CreateTable
CREATE TABLE "product_reviews" (
    "review_id" SERIAL NOT NULL,
    "product_id" INTEGER NOT NULL,
    "client_id" INTEGER NOT NULL,
    "rating" INTEGER NOT NULL,
    "comment" TEXT,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "product_reviews_pkey" PRIMARY KEY ("review_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "categories_category_name_key" ON "categories"("category_name");

-- CreateIndex
CREATE UNIQUE INDEX "clients_client_phone_key" ON "clients"("client_phone");

-- CreateIndex
CREATE UNIQUE INDEX "clients_client_email_key" ON "clients"("client_email");

-- CreateIndex
CREATE UNIQUE INDEX "employee_employee_phone_key" ON "employee"("employee_phone");

-- CreateIndex
CREATE UNIQUE INDEX "employee_employee_email_key" ON "employee"("employee_email");

-- CreateIndex
CREATE UNIQUE INDEX "unique_order_product" ON "order_items"("order_id", "product_id");

-- CreateIndex
CREATE UNIQUE INDEX "unique_warehouse_product" ON "stock_balances"("warehouse_id", "product_id");

-- CreateIndex
CREATE UNIQUE INDEX "supplier_company_name_key" ON "supplier"("company_name");

-- CreateIndex
CREATE UNIQUE INDEX "unique_supply_product" ON "supply_items"("supply_delivery_id", "product_id");

-- AddForeignKey
ALTER TABLE "order_items" ADD CONSTRAINT "order_items_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "orders"("order_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "order_items" ADD CONSTRAINT "order_items_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products"("product_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "orders" ADD CONSTRAINT "orders_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "clients"("client_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "orders" ADD CONSTRAINT "orders_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employee"("employee_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "products" ADD CONSTRAINT "products_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "categories"("category_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "stock_balances" ADD CONSTRAINT "stock_balances_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products"("product_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "stock_balances" ADD CONSTRAINT "stock_balances_warehouse_id_fkey" FOREIGN KEY ("warehouse_id") REFERENCES "warehouse"("warehouse_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "supply_deliver" ADD CONSTRAINT "supply_deliver_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employee"("employee_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "supply_deliver" ADD CONSTRAINT "supply_deliver_supplier_id_fkey" FOREIGN KEY ("supplier_id") REFERENCES "supplier"("supplier_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "supply_deliver" ADD CONSTRAINT "supply_deliver_warehouse_id_fkey" FOREIGN KEY ("warehouse_id") REFERENCES "warehouse"("warehouse_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "supply_items" ADD CONSTRAINT "supply_items_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products"("product_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "supply_items" ADD CONSTRAINT "supply_items_supply_delivery_id_fkey" FOREIGN KEY ("supply_delivery_id") REFERENCES "supply_deliver"("supply_delivery_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "product_reviews" ADD CONSTRAINT "product_reviews_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "clients"("client_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "product_reviews" ADD CONSTRAINT "product_reviews_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products"("product_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
