"use client";

import type { ReactNode } from "react";
import { cx } from "./cx";
import { Icon } from "./icons";
import { Reveal, type RevealVariant } from "./motion";
import s from "./site.module.css";

/** Demo form shell: nothing is sent anywhere yet, so submitting is a no-op. */
export function FormCard({ children, title, reveal = "zoom", label }: { children: ReactNode; title?: string; reveal?: RevealVariant; label: string }) {
	return (
		<Reveal variant={reveal}>
			<form className={s.formcard} aria-label={label} onSubmit={(e) => e.preventDefault()}>
				{title && <h2 className={cx(s.h3, s.formTitle)}>{title}</h2>}
				<div className={s.form}>
					{children}
					<p className={s.formNote}>
						<Icon name="info" size={16} />
						Preview only — this form isn&apos;t connected yet.
					</p>
				</div>
			</form>
		</Reveal>
	);
}

type FieldBase = { id: string; label: string; full?: boolean };

export function TextField({ id, label, full, type = "text", placeholder, inputMode, min }: FieldBase & { type?: string; placeholder?: string; inputMode?: "numeric" | "tel" | "email" | "text"; min?: number }) {
	return (
		<div className={cx(s.field, full && s.full)}>
			<label htmlFor={id}>{label}</label>
			<input id={id} name={id} type={type} placeholder={placeholder} inputMode={inputMode} min={min} />
		</div>
	);
}

export function SelectField({ id, label, full, options }: FieldBase & { options: string[] }) {
	return (
		<div className={cx(s.field, full && s.full)}>
			<label htmlFor={id}>{label}</label>
			<select id={id} name={id}>
				{options.map((o) => (
					<option key={o}>{o}</option>
				))}
			</select>
		</div>
	);
}

export function TextAreaField({ id, label, placeholder }: FieldBase & { placeholder?: string }) {
	return (
		<div className={cx(s.field, s.full)}>
			<label htmlFor={id}>{label}</label>
			<textarea id={id} name={id} placeholder={placeholder} />
		</div>
	);
}

export function CheckGroup({ legend, name, options, checked = [] }: { legend: string; name: string; options: string[]; checked?: string[] }) {
	return (
		<div className={cx(s.field, s.full)}>
			<fieldset>
				<legend>{legend}</legend>
				{options.map((o) => (
					<label key={o} className={s.chk}>
						<input type="checkbox" name={name} value={o} defaultChecked={checked.includes(o)} />
						{o}
					</label>
				))}
			</fieldset>
		</div>
	);
}

export function FormButton({ children }: { children: ReactNode }) {
	return (
		<div className={cx(s.field, s.full)}>
			<button className={cx(s.btn, s.btnGreen)} type="button">
				{children}
			</button>
		</div>
	);
}
